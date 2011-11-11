package utils;

import models.Claim;
import play.Logger;
import play.jobs.Job;
import play.jobs.OnApplicationStart;
import play.test.Fixtures;

@OnApplicationStart
public class Bootstrap extends Job {
    @Override
    public void doJob() {
        if(Claim.count() == 0) {
            Logger.info("Loading initial-data.yml");
            Fixtures.loadModels("initial-data.yml");
        }
    }
}
