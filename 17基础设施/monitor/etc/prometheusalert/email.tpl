{{range .alerts}}
{{if eq .status "firing"}}
<h1>[🔥  告警信息]({{.generatorURL}})</h1>

<h5>开始时间：{{.startsAt}}</h5>
<h5>告警标题：{{.labels.alertname}}</h5>
<h5>告警级别：{{.labels.level}}</h5>
<h5>告警团队：{{.labels.team}}</h5>
<h5>告警信息：{{.valueString}}</h5>
<h5>视图URL：{{.generatorURL}}</h5>
<h5>面板URL：{{.panelURL}}</h5>
<h5>静默URL：{{.silenceURL}}</h5>
<h5>仪表板URL：{{.dashboardURL}}</h5>

{{else}}
<h1>[🎉  恢复信息]({{.generatorURL}})</h1>

<h5>开始时间：{{.startsAt}}</h5>
<h5>恢复标题：{{.labels.alertname}}</h5>
<h5>恢复信息：{{.valueString}}</h5>
<h5>视图URL：{{.generatorURL}}</h5>
<h5>面板URL：{{.panelURL}}</h5>
<h5>静默URL：{{.silenceURL}}</h5>
<h5>仪表板URL：{{.dashboardURL}}</h5>
{{end}}

{{end}}