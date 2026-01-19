{{/*
Expand the name of the chart.
*/}}
{{- define "frkr.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "frkr.fullname" -}}
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
{{- define "frkr.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "frkr.labels" -}}
helm.sh/chart: {{ include "frkr.chart" . }}
{{ include "frkr.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "frkr.selectorLabels" -}}
app.kubernetes.io/name: {{ include "frkr.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
Database Container Specifications
*/}}
{{- define "frkr.db.postgres.container" -}}
- name: postgres
  image: "{{ .Values.infrastructure.postgres.image.repository }}:{{ .Values.infrastructure.postgres.image.tag }}"
  imagePullPolicy: IfNotPresent
  env:
    - name: POSTGRES_USER
      value: "{{ .Values.infrastructure.db.user }}"
    - name: POSTGRES_PASSWORD
      value: "{{ .Values.infrastructure.db.password }}"
    - name: POSTGRES_DB
      value: "{{ .Values.infrastructure.db.name }}"
    - name: PGDATA
      value: /var/lib/postgresql/data/pgdata
  ports:
    - name: postgres
      containerPort: 5432
  readinessProbe:
    exec:
      command:
        - /bin/sh
        - -c
        - exec pg_isready -U {{ .Values.infrastructure.db.user }} -d {{ .Values.infrastructure.db.name }} -h 127.0.0.1 -p 5432
    initialDelaySeconds: 5
    periodSeconds: 10
    timeoutSeconds: 5
  livenessProbe:
    exec:
      command:
        - /bin/sh
        - -c
        - exec pg_isready -U {{ .Values.infrastructure.db.user }} -d {{ .Values.infrastructure.db.name }} -h 127.0.0.1 -p 5432
    initialDelaySeconds: 15
    periodSeconds: 20
    timeoutSeconds: 5
  resources:
    {{- toYaml .Values.infrastructure.postgres.resources | nindent 4 }}
  volumeMounts:
    - name: data
      mountPath: /var/lib/postgresql/data
{{- end }}

{{- define "frkr.db.cockroachdb.container" -}}
- name: cockroachdb
  image: "{{ .Values.infrastructure.cockroachdb.image.repository }}:{{ .Values.infrastructure.cockroachdb.image.tag }}"
  imagePullPolicy: IfNotPresent
  command:
    - "/cockroach/cockroach"
    - "start-single-node"
    - "--insecure"
    - "--http-addr=0.0.0.0"
  ports:
    - containerPort: 26257
      name: cockroach
    - containerPort: 8080
      name: cockroach-dash
  readinessProbe:
    httpGet:
      path: "/health"
      port: 8080
    initialDelaySeconds: 10
    periodSeconds: 5
  livenessProbe:
    httpGet:
      path: "/health"
      port: 8080
    initialDelaySeconds: 30
    periodSeconds: 10
  resources:
    {{- toYaml .Values.infrastructure.cockroachdb.resources | nindent 4 }}
  volumeMounts:
    - name: data
      mountPath: /cockroach/cockroach-data
{{- end }}
