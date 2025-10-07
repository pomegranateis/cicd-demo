# convert-zap-to-sarif.py
import json
import sys

def convert_zap_to_sarif(zap_json_file, sarif_output_file):
    with open(zap_json_file, 'r') as f:
        zap_data = json.load(f)

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

    for site in zap_data.get('site', []):
        for alert in site.get('alerts', []):
            sarif['runs'][0]['results'].append({
                "ruleId": str(alert['pluginid']),
                "level": map_risk_level(alert['riskcode']),
                "message": {
                    "text": alert['alert']
                },
                "locations": [{
                    "physicalLocation": {
                        "artifactLocation": {
                            "uri": alert['url']
                        }
                    }
                }]
            })

    with open(sarif_output_file, 'w') as f:
        json.dump(sarif, f, indent=2)

def map_risk_level(risk_code):
    mapping = {
        '3': 'error',    # High
        '2': 'warning',  # Medium
        '1': 'note',     # Low
        '0': 'none'      # Informational
    }
    return mapping.get(str(risk_code), 'warning')

if __name__ == '__main__':
    convert_zap_to_sarif('zap_report.json', 'zap_report.sarif')
