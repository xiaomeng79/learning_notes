{{range .alerts}}
{{if eq .status "firing"}}
**[🔥  告警信息]({{.generatorURL}})**

开始时间：{{.startsAt}}
告警标题：{{.labels.alertname}}
告警级别：{{.labels.level}}
告警团队：{{.labels.team}}
告警信息：{{.valueString}}
视图URL：{{.generatorURL}}
面板URL：{{.panelURL}}
静默URL：{{.silenceURL}}
仪表板URL：{{.dashboardURL}}

{{else}}
**[🎉  恢复信息]({{.generatorURL}})**

开始时间：{{.startsAt}}
恢复标题：{{.labels.alertname}}
恢复信息：{{.valueString}}
视图URL：{{.generatorURL}}
面板URL：{{.panelURL}}
静默URL：{{.silenceURL}}
仪表板URL：{{.dashboardURL}}
{{end}}

{{end}}