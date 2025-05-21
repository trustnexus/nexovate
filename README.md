# Nexovate Admin Module

Nexovate -- Admin Module is a desktop (windows) flutter application, for the purpose of controlling the main application.

## About

This project is started by Trust Nexus Co. (2025); as a community driven platform for developers ready at hand to work on client projects and clients that need software requirement specifications on their desired projects.


## Version History (Most Recent TO Least Recent)


- Update, Users Page - I
    - Implemented a design where top container is for searching & bottom container(yet to add) is intended for users' list
    - TODO: Add second container for users' list with hardcoded values using UserProvider(yet to add)
    - TODO: UI Pages: Add 2 more pages for `Design` and `Projects` management for the admin

- Theme Universalization - I 
    - Created ChangeValueNotifier extended class "_ThemeModeProvider_" in `lib/viewmodel/notifiers/thememode.dart`
    - Implemented _ThemeModeProvider_ instead of `isDarkMode` variable; also abstracted toggleTheme
    - Added Theme Toggle Icon Button on bottom of side navigation bar in `dashboardpage.dart`
    - Added `utils/textstyles.dart` to further abstract theme
    - TODO: Add `utils/constants/colors.dart` for all colors to be used across pages (unresolved 21/05/2025)

- Initial Commit Of Nexovate Admin Module
    - Implemented MVVM architecture with intention of adding Providers later on
    - Implemented Basic Theme Toggle (without provider)
    - Added Login Page
    - Added Dashboard Page that may contain subpages: (Users, Questions, Settings, Logout)

