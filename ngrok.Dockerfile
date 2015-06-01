FROM scratch
ADD ngrokroot.crt.tar.gz /src/ngrok/assets/client/tls
COPY build/assets/client/tls/ngrokroot.crt /data/ngrokroot.crt
COPY build/assets/client/tls/snakeoilca.crt /src/ngrok/assets/client/tls/
COPY build/ngrok /
VOLUME ["/data"]
ENTRYPOINT ["/ngrok"]
CMD ["--help"]
