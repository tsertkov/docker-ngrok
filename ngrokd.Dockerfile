FROM scratch
COPY build/ngrokd /
EXPOSE 80 443 4443
VOLUME ["/data"]
ENTRYPOINT ["/ngrokd"]
CMD ["--help"]
