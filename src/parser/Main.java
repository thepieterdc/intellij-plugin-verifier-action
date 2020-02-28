/*
 * Copyright (c) 2019-2020. All rights reserved.
 *
 * @author Pieter De Clercq
 *
 * https://github.com/thepieterdc/intellij-plugin-verifier-action/
 */

package parser;

import java.util.Arrays;

/**
 * Main entry point.
 */
public class Main {
	/**
	 * Name of the environment variable that contains the versions.
	 */
	private static final String ARG_VERSIONS = "INPUT_VERSIONS";
	
	/**
	 * Gets the release type.
	 *
	 * @param version the version string
	 * @return the release type
	 */
	private static String getReleaseType(final String version) {
		if (version.endsWith("-EAP-SNAPSHOT")
			|| version.endsWith("-EAP-CANDIDATE-SNAPSHOT")
			|| version.endsWith("-CUSTOM-SNAPSHOT")) {
			return "snapshots";
		}
		if (version.endsWith("-SNAPSHOT")) {
			return "nightly";
		}
		return "releases";
	}
	
	/**
	 * Gets the url to download the given version.
	 *
	 * @param version the version to parse
	 * @return the url
	 */
	private static String getUrl(final String version) {
		// Get the release type.
		final String releaseType = getReleaseType(version);

		// Construct the url.
		return String.format("https://www.jetbrains.com/intellij-repository/%s/com/jetbrains/intellij/idea/ideaIU/%s/ideaIU-%s.zip",
			releaseType,
			version,
			version
			);
	}
	
	/**
	 * Main method.
	 *
	 * @param args unused
	 */
	public static void main(String[] args) {
		// Get the versions to test.
		final String[] versions = System.getenv(ARG_VERSIONS).split("\n");
		
		// Parse every version and print the download paths.
		Arrays.stream(versions).map(Main::getUrl).forEach(System.out::println);
	}
}
