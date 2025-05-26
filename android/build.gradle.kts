// Root-level build.gradle.kts for Firebase + Google Sign-In

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // ✅ Firebase Gradle plugin for google-services.json
        classpath("com.google.gms:google-services:4.3.15")
        // ✅ Android Gradle plugin (match Flutter recommended)
        classpath("com.android.tools.build:gradle:8.2.1")
        // ✅ Kotlin plugin
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.10")
    }
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
