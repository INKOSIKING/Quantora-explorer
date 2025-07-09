def security_scan():
    criticalIssues = 0  # Example: Replace with actual issue count

    results = {
        "vulnerableDependencies": 5,
        "outdatedLibraries": 2,
        "highSeverityVulnerabilities": 1,
        "mediumSeverityVulnerabilities": 3,
        "lowSeverityVulnerabilities": 0,
        "soxCompliant": criticalIssues == 0,  # Syntax error fixed
    }

    print("Security Scan Results:")
    for key, value in results.items():
        print(f"{key}: {value}")

security_scan()