#!/usr/bin/env python3
# convert-zap-to-sarif.py
import json
import sys
import os
from datetime import datetime

def convert_zap_to_sarif(zap_json_file, sarif_output_file):
    """Convert ZAP JSON report to SARIF format."""
    
    # Check if input file exists
    if not os.path.exists(zap_json_file):
        print(f"Error: ZAP JSON file '{zap_json_file}' not found")
        return False
    
    try:
        with open(zap_json_file, 'r') as f:
            zap_data = json.load(f)
    except Exception as e:
        print(f"Error reading '{zap_json_file}': {e}")
        return False

    sarif = {
        "version": "2.1.0",
        "$schema": "https://raw.githubusercontent.com/oasis-tcs/sarif-spec/master/Schemata/sarif-schema-2.1.0.json",
        "runs": [{
            "tool": {
                "driver": {
                    "name": "OWASP ZAP",
                    "version": "2.14.0",
                    "informationUri": "https://www.zaproxy.org/"
                }
            },
            "results": []
        }]
    }

    # Process ZAP alerts
    if 'site' in zap_data and isinstance(zap_data['site'], list):
        for site in zap_data['site']:
            if 'alerts' in site and isinstance(site['alerts'], list):
                for alert in site['alerts']:
                    sarif["runs"][0]["results"].append({
                        "ruleId": alert.get('pluginid', 'unknown'),
                        "message": {
                            "text": alert.get('desc', 'No description available')
                        },
                        "level": map_risk_level(alert.get('riskcode', '0')),
                        "locations": [{
                            "physicalLocation": {
                                "artifactLocation": {
                                    "uri": alert.get('url', 'unknown')
                                }
                            }
                        }]
                    })

    try:
        with open(sarif_output_file, 'w') as f:
            json.dump(sarif, f, indent=2)
        print(f"Successfully converted to SARIF: {sarif_output_file}")
        return True
    except Exception as e:
        print(f"Error writing SARIF file '{sarif_output_file}': {e}")
        return False

def map_risk_level(risk_code):
    """Convert ZAP risk code to SARIF level."""
    mapping = {
        '3': 'error',    # High
        '2': 'warning',  # Medium
        '1': 'note',     # Low
        '0': 'note'      # Informational
    }
    return mapping.get(str(risk_code), 'warning')

if __name__ == '__main__':
    if len(sys.argv) >= 3:
        input_file = sys.argv[1]
        output_file = sys.argv[2]
    else:
        # Default filenames for backward compatibility
        input_file = 'report.json'
        output_file = 'report.sarif'
    
    # Try different possible input filenames
    possible_files = [input_file, 'report.json', 'zap_report.json']
    
    success = False
    for filename in possible_files:
        if os.path.exists(filename):
            print(f"Found ZAP report: {filename}")
            success = convert_zap_to_sarif(filename, output_file)
            break
    
    if not success:
        print(f"Error: No ZAP JSON report found. Tried: {', '.join(possible_files)}")
        sys.exit(1)
