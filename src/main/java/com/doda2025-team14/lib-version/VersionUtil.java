package com.doda2025_team14.lib_version;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class VersionUtil {

    private static final String VERSION_PROPERTIES = "/version.properties";
    private static String version;

    public static String getVersion() {
        if (version == null) {
            version = loadVersion();
        }
        return version;
    }

    private static String loadVersion() {
        Properties props = new Properties();

        try (InputStream is = VersionUtil.class.getResourceAsStream(VERSION_PROPERTIES)) {
            if (is != null) {
                props.load(is);
            } else {
                return "unknown";
            }
        } catch (IOException e) {
            return "unknown";
        }

        String ver = props.getProperty("version", "").trim();

        if (!ver.isEmpty() && !ver.startsWith("${")) {
            return ver;
        }
        return "unknown";
    }
}