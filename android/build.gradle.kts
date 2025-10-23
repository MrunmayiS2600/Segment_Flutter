buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Kotlin DSL uses parentheses and double quotes
        classpath("com.google.gms:google-services:4.3.3")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}


// Ensure app module is evaluated before others if needed
subprojects {
    project.evaluationDependsOn(":app")
}

// Register clean task
tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
