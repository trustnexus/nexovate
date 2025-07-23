# Nexovate -- Powered By Trust Nexus

An Automated Community Driven Platform for the purposes of Scope Document Generation, and much more!

## Editions

- Backend API Integration II (23/07/2025)
    - Added `Document Downloading` from the API endpoint: `/download:fileName`
    - Added `/generate` whenever the project is saved, used Hivebox to get the generated documents' filenae for the downloading.


- Backend API Integration I (22/07/2025)
    - Added `services` folder, for the API service connections (used them wherever necessary)
    - Added `constants.dart` in the services folder, for the purpose of changing IP (should be in .env instead, though)
    - Added `assets/anims` folder, for the Lottie Animations, replaced previous held: circular progress indicator.
    - Deprecated previous local questionnaire storage, added HiveBox implementation instead. DEPRECATED: `utils/questionnaire_storage.dart`
    - Added `providers` for state management.
    - Added `Prompt Screen - prompt.dart`, for the purpose of drafting scope document, and refining
    - Added `utils/toast.dart` as a custom toast, replacing all the previously used Snackbars usecase: `showToast(context, message)`
    - Added `models` containing various DTOs (Data Transfer Objects) necessitating data transfer from API to frontend.


## TODO:
- To add `Document Downloading`, from the API endpoint: `/download:fileName` [DONE: Backend API Integration II, 23/07/2025]
- To add `/generate`, whenever the project is saved! and use Hivebox to get the generated documents' filename for the downloading. [DONE: Backend API Integration II, 23/07/2025]
