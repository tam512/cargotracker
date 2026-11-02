package net.java.cargotracker.application.util;

import java.util.HashSet;
import java.util.Set;
import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;
import net.java.cargotracker.interfaces.booking.rest.CargoMonitoringService;
import net.java.cargotracker.interfaces.handling.rest.HandlingReportService;
import net.java.pathfinder.api.GraphTraversalService;

/**
 * JAX-RS configuration.
 *
 * A plain {@link Application} is used rather than Jersey's ResourceConfig: with
 * ResourceConfig on the server classpath, TomEE also deploys a root-mapped
 * ResourceConfig application that answers 404 for /javax.faces.resource/*.
 */
@ApplicationPath("rest")
public class RestConfiguration extends Application {

    @Override
    public Set<Class<?>> getClasses() {
        Set<Class<?>> classes = new HashSet<>();
        classes.add(HandlingReportService.class);
        classes.add(GraphTraversalService.class);
        classes.add(CargoMonitoringService.class);
        return classes;
    }
}
