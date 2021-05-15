FROM itzg/minecraft-server

COPY myStart /

RUN dos2unix /myStart && chmod +x /myStart

ENTRYPOINT [ "/myStart" ]