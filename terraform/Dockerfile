FROM nginx:alpine

RUN rm -f /usr/share/nginx/html/index.html

RUN printf '%s\n' \
'<!DOCTYPE html>' \
'<html>' \
'<head>' \
'    <title>TalentFlow AI</title>' \
'</head>' \
'<body>' \
'    <h1>TalentFlow AI</h1>' \
'    <h2>Docker Container</h2>' \
'    <p>TalentFlow AI application is running successfully inside a Docker container.</p>' \
'    <p>Environment: Dev</p>' \
'</body>' \
'</html>' \
> /usr/share/nginx/html/index.html

EXPOSE 80