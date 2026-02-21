# Implementation Plan - Authentication & Role-Based Navigation

## Phase 1: Core Updates
- [ ] 1. Update UserModel to include proper role field and child-related data
- [ ] 2. Update ChildModel to include authentication credentials
- [ ] 3. Create UserRole enum for type safety

## Phase 2: Authentication Flow
- [ ] 4. Update AuthController to handle role detection after login
- [ ] 5. Update SplashController to check user role and navigate accordingly
- [ ] 6. Create role-based route constants

## Phase 3: Child Management
- [ ] 7. Create child management screen (list, add, edit, delete)
- [ ] 8. Update ChildRepository for full CRUD operations
- [ ] 9. Create child authentication service

## Phase 4: Dashboard Updates
- [ ] 10. Update Parent Dashboard with children management section
- [ ] 11. Create Child Dashboard with map-first experience
- [ ] 12. Update bottom navigation for different roles

## Phase 5: Security & UI
- [ ] 13. Update Firestore security rules
- [ ] 14. Create reusable widgets for child management
- [ ] 15. Final testing and verification

## Implementation Status:
- Phase 1: [ ]
- Phase 2: [ ]
- Phase 3: [ ]
- Phase 4: [ ]
- Phase 5: [ ]
