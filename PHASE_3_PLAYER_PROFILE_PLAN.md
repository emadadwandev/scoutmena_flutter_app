# Phase 3: Player Profile Module - Implementation Plan

**Status**: 🚀 Starting Implementation
**Duration**: 2 weeks (84 hours estimated)
**Tasks**: 10 tasks
**Priority**: 🔴 Critical

---

## 📊 Task Overview

| Task | Description | Priority | Time | Status |
|------|-------------|----------|------|--------|
| 3.1 | Player Profile Data Layer | 🔴 Critical | 8h | ⏳ Pending |
| 3.2 | Player Profile Domain Layer | 🔴 Critical | 6h | ⏳ Pending |
| 3.3 | Player Profile BLoC | 🔴 Critical | 6h | ⏳ Pending |
| 3.4 | Player Profile Setup Flow | 🔴 Critical | 12h | ⏳ Pending |
| 3.5 | Player Profile View Screen | 🟡 High | 8h | ⏳ Pending |
| 3.6 | Player Profile Edit Screen | 🟡 High | 6h | ⏳ Pending |
| 3.7 | Photo Upload & Gallery | 🔴 Critical | 10h | ⏳ Pending |
| 3.8 | Video Upload & Player | 🔴 Critical | 12h | ⏳ Pending |
| 3.9 | Statistics Management | 🟡 High | 8h | ⏳ Pending |
| 3.10 | Profile Analytics Screen | 🟢 Medium | 6h | ⏳ Pending |

**Total Estimated Time**: 84 hours

---

## 🎯 Implementation Order

### Week 1: Core Profile Features (Tasks 3.1-3.6)
1. **Day 1-2**: Data Layer & Domain Layer (Tasks 3.1, 3.2)
2. **Day 3**: BLoC Layer (Task 3.3)
3. **Day 4-5**: Profile Setup Flow (Task 3.4)
4. **Day 6**: Profile View Screen (Task 3.5)
5. **Day 7**: Profile Edit Screen (Task 3.6)

### Week 2: Media & Advanced Features (Tasks 3.7-3.10)
1. **Day 8-9**: Photo Upload & Gallery (Task 3.7)
2. **Day 10-11**: Video Upload & Player (Task 3.8)
3. **Day 12**: Statistics Management (Task 3.9)
4. **Day 13**: Profile Analytics (Task 3.10)
5. **Day 14**: Testing & Bug Fixes

---

## 📝 Detailed Task Breakdown

### Task 3.1: Player Profile Data Layer (8 hours)

**Files to Create:**
```
lib/features/player_profile/
├── data/
│   ├── datasources/
│   │   ├── player_remote_datasource.dart
│   │   └── player_local_datasource.dart (optional)
│   ├── models/
│   │   ├── player_profile_model.dart
│   │   ├── player_photo_model.dart
│   │   ├── player_video_model.dart
│   │   └── player_stat_model.dart
│   └── repositories/
│       └── player_repository_impl.dart
```

**Backend Endpoints to Integrate:**
- `GET /api/v1/player/profile` - Get profile
- `POST /api/v1/player/profile` - Create profile
- `PUT /api/v1/player/profile` - Update profile
- `POST /api/v1/player/profile/photo` - Upload profile photo
- `GET /api/v1/player/profile/photos` - Get gallery photos
- `POST /api/v1/player/profile/photos` - Upload gallery photo
- `DELETE /api/v1/player/profile/photos/{photo}` - Delete photo
- `GET /api/v1/player/profile/videos` - Get videos
- `POST /api/v1/player/profile/videos` - Upload video
- `DELETE /api/v1/player/profile/videos/{video}` - Delete video
- `GET /api/v1/player/profile/videos/{video}/status` - Check processing
- `GET /api/v1/player/profile/stats` - Get statistics
- `POST /api/v1/player/profile/stats` - Create stats
- `GET /api/v1/player/profile/analytics` - Get analytics

**Key Features:**
- JSON serialization/deserialization
- Error handling
- Upload progress tracking for photos/videos
- Multipart file upload support

---

### Task 3.2: Player Profile Domain Layer (6 hours)

**Files to Create:**
```
lib/features/player_profile/
├── domain/
│   ├── entities/
│   │   ├── player_profile.dart
│   │   ├── player_photo.dart
│   │   ├── player_video.dart
│   │   └── player_stat.dart
│   ├── repositories/
│   │   └── player_repository.dart
│   └── usecases/
│       ├── create_profile.dart
│       ├── update_profile.dart
│       ├── get_profile.dart
│       ├── upload_photo.dart
│       ├── upload_video.dart
│       ├── delete_photo.dart
│       ├── delete_video.dart
│       ├── update_statistics.dart
│       └── get_analytics.dart
```

**Entity Relationships:**
```
PlayerProfile
  ├── id: String
  ├── userId: String
  ├── name: String
  ├── dateOfBirth: DateTime
  ├── nationality: String
  ├── height: double
  ├── weight: double
  ├── dominantFoot: String
  ├── currentClub: String
  ├── position: List<String>
  ├── jerseyNumber: int?
  ├── yearsPlaying: int
  ├── profilePhotoUrl: String?
  ├── photos: List<PlayerPhoto>
  ├── videos: List<PlayerVideo>
  ├── statistics: PlayerStat?
  └── createdAt: DateTime
```

---

### Task 3.3: Player Profile BLoC (6 hours)

**Files to Create:**
```
lib/features/player_profile/
└── presentation/
    └── bloc/
        ├── player_profile/
        │   ├── player_profile_bloc.dart
        │   ├── player_profile_event.dart
        │   └── player_profile_state.dart
        ├── photo_upload/
        │   ├── photo_upload_bloc.dart
        │   ├── photo_upload_event.dart
        │   └── photo_upload_state.dart
        ├── video_upload/
        │   ├── video_upload_bloc.dart
        │   ├── video_upload_event.dart
        │   └── video_upload_state.dart
        └── statistics/
            ├── statistics_bloc.dart
            ├── statistics_event.dart
            └── statistics_state.dart
```

**BLoC Events:**
- PlayerProfile: LoadProfile, CreateProfile, UpdateProfile, DeleteProfile
- PhotoUpload: UploadPhotos, DeletePhoto, ReorderPhotos
- VideoUpload: UploadVideo, DeleteVideo, CheckVideoStatus
- Statistics: LoadStatistics, UpdateStatistics

**BLoC States:**
- Initial, Loading, Loaded, Error
- UploadProgress (with percentage)
- VideoProcessing (with status)

---

### Task 3.4: Player Profile Setup Flow (12 hours) - MULTI-STEP FORM

**Files to Create:**
```
lib/features/player_profile/
└── presentation/
    ├── pages/
    │   └── player_profile_setup_page.dart
    └── widgets/
        ├── profile_setup/
        │   ├── basic_info_step.dart
        │   ├── football_info_step.dart
        │   ├── contact_step.dart
        │   └── parent_info_step.dart
        ├── profile_photo_picker.dart
        ├── position_selector.dart
        └── dominant_foot_selector.dart
```

**4-Step Form Flow:**

**Step 1: Basic Information**
- Profile photo upload (circular)
- Full name (prefilled from registration)
- Date of birth (prefilled)
- Nationality (dropdown with flags)
- Height (cm) & Weight (kg)
- Dominant foot (Left/Right/Both)

**Step 2: Football Information**
- Current club (text input)
- Position selector (multi-select chips)
  - Goalkeeper, Defender, Midfielder, Forward
- Jersey number (optional)
- Years playing (number input)

**Step 3: Contact & Social**
- Email (prefilled, read-only)
- Phone (prefilled, read-only)
- Instagram handle (optional)
- Twitter handle (optional)

**Step 4: Parent Information** (if user is minor)
- Parent name
- Parent email
- Parent phone
- Emergency contact
- Show "Awaiting Parental Consent" status

**UI Features:**
- Stepper widget with progress indicator
- Form validation on each step
- Back/Continue buttons
- Auto-save draft (optional)
- Loading states
- Error handling

---

### Task 3.5: Player Profile View Screen (8 hours)

**Files to Create:**
```
lib/features/player_profile/
└── presentation/
    ├── pages/
    │   └── player_profile_page.dart
    └── widgets/
        ├── profile_header.dart
        ├── profile_info_section.dart
        ├── photo_gallery_widget.dart
        ├── video_gallery_widget.dart
        └── statistics_widget.dart
```

**Screen Sections:**

1. **Profile Header**
   - Profile photo (circular, large)
   - Player name
   - Position badges
   - Age
   - Country flag + nationality

2. **Personal Information Card**
   - Height & Weight
   - Dominant foot
   - Current club
   - Jersey number
   - Years playing

3. **Contact Information** (if not hidden by privacy)
   - Email
   - Phone
   - Social media handles

4. **Photo Gallery** (horizontal scroll)
   - Thumbnail grid
   - Tap to view fullscreen
   - Moderation status badges

5. **Video Gallery** (horizontal scroll)
   - Video thumbnails with play button
   - Processing status indicator
   - Tap to play

6. **Statistics Card** (if available)
   - Matches played
   - Goals & Assists
   - Cards

7. **Action Buttons** (floating or bottom)
   - Edit Profile
   - Settings
   - Share Profile

---

### Task 3.6: Player Profile Edit Screen (6 hours)

**Files to Create:**
```
lib/features/player_profile/
└── presentation/
    └── pages/
        └── edit_profile_page.dart
```

**Features:**
- Pre-fill all fields with existing data
- Same form structure as setup (without steps)
- Profile photo update
- Save/Cancel buttons
- Loading state on save
- Success/Error messages
- Navigate back on success

**Editable Fields:**
- Profile photo
- Height & Weight
- Dominant foot
- Current club
- Position
- Jersey number
- Years playing
- Social media handles

**Non-editable:**
- Name (from registration)
- Date of birth
- Nationality
- Email
- Phone

---

### Task 3.7: Photo Upload & Gallery (10 hours)

**Files to Create:**
```
lib/features/player_profile/
└── presentation/
    ├── pages/
    │   ├── photo_upload_page.dart
    │   └── photo_fullscreen_page.dart
    └── widgets/
        ├── photo_picker_widget.dart
        ├── photo_grid_item.dart
        ├── upload_progress_indicator.dart
        └── moderation_status_badge.dart
```

**Features:**

1. **Photo Picker**
   - Multi-image selection (max 10 photos)
   - Camera or gallery
   - Image cropping (square aspect ratio)
   - Preview before upload

2. **Photo Grid**
   - 3-column grid layout
   - Delete button on each photo
   - Crop button
   - Caption input (optional)
   - Drag to reorder (optional)

3. **Upload Progress**
   - Progress bar for each photo
   - Total upload progress
   - Cancel upload option

4. **Moderation Status**
   - Pending: Yellow badge
   - Approved: Green checkmark
   - Rejected: Red X with reason

5. **Gallery View**
   - Tap photo → Fullscreen
   - Pinch to zoom
   - Swipe between photos
   - Share photo option

**Technical:**
- Use `image_picker` package
- Use `image_cropper` package
- Multipart file upload with progress
- Optimize images before upload (compress)

---

### Task 3.8: Video Upload & Player (12 hours)

**Files to Create:**
```
lib/features/player_profile/
└── presentation/
    ├── pages/
    │   ├── video_upload_page.dart
    │   └── video_player_page.dart
    └── widgets/
        ├── video_picker_widget.dart
        ├── video_thumbnail.dart
        ├── video_status_widget.dart
        ├── video_upload_progress.dart
        └── video_player_controls.dart
```

**Features:**

1. **Video Upload**
   - Pick from gallery or record
   - Max size: 500MB
   - Formats: MP4, MOV, AVI
   - Title & description input
   - Video preview before upload

2. **Upload Progress**
   - Upload progress bar (0-100%)
   - Cancel upload
   - Show file size & estimated time

3. **Processing Status** (Poll every 3 seconds)
   - `uploading` → "Uploading video..."
   - `pending` → "Waiting to process..."
   - `processing` → "Processing: X%"
   - `completed` → "Video ready!"
   - `failed` → "Processing failed" (with retry)

4. **Video Player**
   - Custom controls (play/pause, seek, fullscreen)
   - Multiple resolutions (1080p, 720p, 480p)
   - Thumbnail preview
   - Share video option

5. **Video Gallery**
   - List of videos with thumbnails
   - Processing status indicator
   - Tap to play
   - Delete video

**Technical:**
- Use `video_player` package
- Poll status endpoint every 3s during processing
- Show thumbnail from backend
- Handle different video statuses gracefully

**Status Polling Logic:**
```dart
Timer? _statusTimer;

void _startStatusPolling(String videoId) {
  _statusTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
    final status = await checkVideoStatus(videoId);

    if (status == 'completed' || status == 'failed') {
      timer.cancel();
      // Update UI
    }
  });
}

@override
void dispose() {
  _statusTimer?.cancel();
  super.dispose();
}
```

---

### Task 3.9: Statistics Management (8 hours)

**Files to Create:**
```
lib/features/player_profile/
└── presentation/
    ├── pages/
    │   └── statistics_page.dart
    └── widgets/
        ├── stat_input_card.dart
        ├── season_selector.dart
        └── stat_chart.dart (optional)
```

**Features:**

1. **Season/Year Selector**
   - Dropdown to select season
   - Add new season

2. **Stat Input Cards**
   - Matches Played
   - Goals
   - Assists
   - Yellow Cards
   - Red Cards
   - Minutes Played
   - Clean sheets (for goalkeepers)

3. **Visual Display**
   - Number cards with icons
   - Simple bar charts (optional)
   - Compare seasons (optional)

4. **Actions**
   - Save statistics
   - Edit existing stats
   - Delete season stats

**UI Design:**
- Card-based layout
- Each stat as editable card
- Color-coded (green for positive stats)
- Save button at bottom

---

### Task 3.10: Profile Analytics Screen (6 hours)

**Files to Create:**
```
lib/features/player_profile/
└── presentation/
    ├── pages/
    │   └── profile_analytics_page.dart
    └── widgets/
        ├── analytics_summary_card.dart
        ├── views_chart.dart
        └── scout_viewer_list.dart
```

**Features:**

1. **Analytics Summary**
   - Total profile views
   - Views this week
   - Views this month
   - Unique scouts

2. **Views Chart**
   - Line chart showing views over time
   - Date range selector (7 days, 30 days, all time)

3. **Scout Viewers List**
   - List of scouts who viewed profile
   - Scout name & organization
   - View date/time
   - Tap to view scout profile (optional)

4. **Insights** (optional)
   - Most viewed day
   - Peak viewing time
   - Average views per day

**Backend Endpoint:**
- `GET /api/v1/player/profile/analytics`

**Response:**
```json
{
  "total_views": 150,
  "views_this_week": 25,
  "views_this_month": 80,
  "unique_scouts": 45,
  "views_by_date": [
    {"date": "2025-11-01", "count": 10},
    {"date": "2025-11-02", "count": 15}
  ],
  "recent_viewers": [
    {
      "scout_id": "123",
      "scout_name": "John Doe",
      "organization": "FC Barcelona",
      "viewed_at": "2025-11-12T10:30:00Z"
    }
  ]
}
```

---

## 🎨 Design Guidelines

### Colors (from app_colors.dart)
- Primary (Player): `#3B82F6` (Blue)
- Success: `#10B981` (Green)
- Warning: `#F59E0B` (Orange)
- Error: `#DC2626` (Red)
- Background: `#F9FAFB`
- Surface: `#FFFFFF`

### Typography (Google Fonts)
- **English**: Tomorrow font
- **Arabic**: Cairo font

### Component Styling
- **Cards**: Rounded corners (12px), elevation 2
- **Buttons**: Rounded (12px), 56px height
- **Input Fields**: Outlined, rounded (12px)
- **Images**: Rounded corners (8px)

### Spacing
- Small: 8px
- Medium: 16px
- Large: 24px
- XLarge: 32px

---

## 🧪 Testing Strategy

### Unit Tests
- [ ] Test all PlayerProfile BLoC events/states
- [ ] Test PhotoUpload BLoC with progress
- [ ] Test VideoUpload BLoC with status polling
- [ ] Test Statistics BLoC
- [ ] Test all use cases
- [ ] Test repository implementations
- [ ] Test model serialization

### Widget Tests
- [ ] Test profile setup stepper navigation
- [ ] Test form validation
- [ ] Test photo picker widget
- [ ] Test video status widget
- [ ] Test statistics input cards

### Integration Tests
- [ ] Complete profile creation flow
- [ ] Photo upload → Gallery → Delete
- [ ] Video upload → Processing → Playback
- [ ] Statistics CRUD operations
- [ ] Profile edit → Save → View

---

## 📦 Dependencies to Add

Add to `pubspec.yaml`:
```yaml
dependencies:
  # Already added in Phase 1
  image_picker: ^1.0.4
  image_cropper: ^5.0.0
  video_player: ^2.8.1
  cached_network_image: ^3.3.0
  photo_view: ^0.14.0

  # May need to add
  flutter_chart: ^0.1.0  # For analytics charts (optional)
  percent_indicator: ^4.2.3  # For upload progress
```

---

## ⚠️ Important Considerations

### COPPA Compliance (Minors)
- Minors' profiles show "Awaiting Parental Consent" status
- All uploads from minors go through moderation
- Parent must approve content before it's visible
- Privacy defaults to "Scouts Only" for minors

### Content Moderation
- All photos/videos start as "pending"
- Backend moderates content
- Show moderation status clearly
- Allow players to edit/resubmit rejected content

### Performance
- Optimize image sizes before upload (compress)
- Lazy load photo/video galleries
- Cache profile data locally
- Use pagination for analytics data

### Error Handling
- Network errors → Show retry option
- Upload failures → Allow retry
- Video processing failures → Show error with retry
- Form validation errors → Clear messaging

---

## 🚀 Getting Started

### Step 1: Set up folder structure
```bash
cd lib/features
mkdir -p player_profile/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}
```

### Step 2: Start with Data Layer (Task 3.1)
- Create models
- Create remote data source
- Create repository implementation

### Step 3: Build Domain Layer (Task 3.2)
- Create entities
- Create repository interface
- Create use cases

### Step 4: Implement BLoCs (Task 3.3)
- PlayerProfileBloc
- PhotoUploadBloc
- VideoUploadBloc
- StatisticsBloc

### Step 5: Build UI (Tasks 3.4-3.10)
- Profile setup flow
- Profile view
- Photo/Video upload
- Statistics & Analytics

---

## 📊 Progress Tracking

Update this table as tasks are completed:

| Task | Start Date | End Date | Actual Hours | Status | Notes |
|------|------------|----------|--------------|--------|-------|
| 3.1 | | | | ⏳ | |
| 3.2 | | | | ⏳ | |
| 3.3 | | | | ⏳ | |
| 3.4 | | | | ⏳ | |
| 3.5 | | | | ⏳ | |
| 3.6 | | | | ⏳ | |
| 3.7 | | | | ⏳ | |
| 3.8 | | | | ⏳ | |
| 3.9 | | | | ⏳ | |
| 3.10 | | | | ⏳ | |

**Legend:**
- ⏳ Pending
- 🚧 In Progress
- ✅ Complete
- ⚠️ Blocked
- ❌ Cancelled

---

## 🎯 Success Criteria

Phase 3 is complete when:
- [x] Player can create complete profile
- [x] Player can edit profile
- [x] Player can upload photos (with cropping)
- [x] Player can upload videos
- [x] Videos process successfully
- [x] Statistics can be entered and saved
- [x] Profile displays correctly
- [x] Analytics are visible
- [x] All CRUD operations work
- [x] Moderation statuses display correctly
- [x] COPPA compliance for minors
- [x] All unit tests pass (80%+ coverage)
- [x] Integration tests pass
- [x] No critical bugs

---

**Ready to start implementation!** 🚀

Let me know which task you'd like to start with, or if you'd like me to begin with Task 3.1 (Data Layer).
