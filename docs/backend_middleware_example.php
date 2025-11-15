<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Firebase Authentication Middleware with UI Testing Bypass
 * 
 * IMPORTANT: The bypass is only active in local development environment
 * with debug mode enabled. Never enable in production!
 */
class FirebaseAuthenticate
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        // ========================================
        // UI TESTING BYPASS (Development Only)
        // ========================================
        if ($this->shouldBypassForUITesting($request)) {
            return $this->handleMockAuthentication($request, $next);
        }

        // ========================================
        // NORMAL FIREBASE TOKEN VALIDATION
        // ========================================
        return $this->handleFirebaseAuthentication($request, $next);
    }

    /**
     * Check if request should bypass Firebase auth for UI testing
     */
    private function shouldBypassForUITesting(Request $request): bool
    {
        // Only in local development with debug enabled
        if (config('app.env') !== 'local' || config('app.debug') !== true) {
            return false;
        }

        // Check for mock token
        $token = $request->bearerToken();
        return $token === 'mock-firebase-token-for-testing';
    }

    /**
     * Handle mock authentication for UI testing
     */
    private function handleMockAuthentication(Request $request, Closure $next): Response
    {
        \Log::info('🎨 UI Testing Mode: Using mock authentication');

        // Attach mock user data to request
        $request->merge([
            'firebase_uid' => 'test-user-123',
            'firebase_email' => 'test@scoutmena.com',
            'firebase_phone' => '+1234567890',
            'is_mock_auth' => true,
            'mock_timestamp' => now()->toIso8601String(),
        ]);

        // You can also attach a mock User model if needed
        // $mockUser = User::where('firebase_uid', 'test-user-123')->first();
        // if ($mockUser) {
        //     $request->setUserResolver(fn () => $mockUser);
        // }

        return $next($request);
    }

    /**
     * Handle normal Firebase token authentication
     */
    private function handleFirebaseAuthentication(Request $request, Closure $next): Response
    {
        try {
            $token = $request->bearerToken();

            if (!$token) {
                return response()->json([
                    'success' => false,
                    'message' => 'Authorization token not provided',
                    'error_code' => 'TOKEN_MISSING',
                ], 401);
            }

            // Initialize Firebase Auth (assuming you have Firebase Admin SDK installed)
            $auth = app('firebase.auth');

            // Verify the token
            $verifiedIdToken = $auth->verifyIdToken($token);
            $firebaseUid = $verifiedIdToken->claims()->get('sub');

            // Find or create user
            $user = \App\Models\User::where('firebase_uid', $firebaseUid)->first();

            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'User not found. Please complete registration.',
                    'error_code' => 'USER_NOT_FOUND',
                ], 404);
            }

            // Check if user is active
            if (!$user->is_active) {
                return response()->json([
                    'success' => false,
                    'message' => 'Account is inactive. Please contact support.',
                    'error_code' => 'ACCOUNT_INACTIVE',
                ], 403);
            }

            // Attach user to request
            $request->setUserResolver(fn () => $user);
            $request->merge([
                'firebase_uid' => $firebaseUid,
                'firebase_email' => $verifiedIdToken->claims()->get('email'),
                'firebase_phone' => $verifiedIdToken->claims()->get('phone_number'),
            ]);

            return $next($request);

        } catch (\Firebase\Auth\Token\Exception\InvalidToken $e) {
            \Log::warning('Invalid Firebase token', [
                'error' => $e->getMessage(),
                'token_preview' => substr($token ?? '', 0, 20) . '...',
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Invalid or expired token. Please login again.',
                'error_code' => 'TOKEN_INVALID',
            ], 401);

        } catch (\Exception $e) {
            \Log::error('Firebase authentication error', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Authentication failed. Please try again.',
                'error_code' => 'AUTH_ERROR',
            ], 500);
        }
    }
}
