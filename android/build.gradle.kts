// Root-level build.gradle.kts for Firebase + Google Sign-In

plugins {
    // We declare plugins here and apply them in the app-level build.gradle.kts
    // `apply false` makes the plugin available to subprojects but does not apply it to the root project.
    id("com.android.application") version "8.7.0" apply false
    id("org.jetbrains.kotlin.android") version "1.8.22" apply false
    id("com.google.gms.google-services") version "4.3.15" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ✅ Optional: Custom build directory (you may remove if unnecessary)
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}
