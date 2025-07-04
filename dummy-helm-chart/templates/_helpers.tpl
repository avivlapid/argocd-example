{{/*
Expand the name of the chart.
*/}}
{{- define "dummy-helm-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "dummy-helm-chart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "dummy-helm-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "dummy-helm-chart.labels" -}}
helm.sh/chart: {{ include "dummy-helm-chart.chart" . }}
{{ include "dummy-helm-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.environment }}
gitops.example.com/environment: {{ .Values.environment }}
{{- end }}
{{- if .Values.deployment.version }}
gitops.example.com/version: {{ .Values.deployment.version }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "dummy-helm-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dummy-helm-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }} 