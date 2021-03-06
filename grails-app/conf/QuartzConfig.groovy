quartz {
    autoStartup = true
    jdbcStore = false
    waitForJobsToCompleteOnShutdown = true
    exposeSchedulerInRepository = false

    props {
        scheduler.skipUpdateCheck = true
    }
}

environments {
    test {
        quartz {
            autoStartup = false
        }
    }
    production {
        quartz {
            autoStartup = true
        }
    }
    development {
        quartz {
            autoStartup = false
        }
    }
}
