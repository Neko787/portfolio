# Packages the portfolio site into a small web server image (nginx).
#
# Build:  docker build -t portfolio .
# Run:    docker run --rm -p 8080:80 portfolio
# Then open http://localhost:8080

FROM nginx:alpine
COPY index.html style.css /usr/share/nginx/html/
