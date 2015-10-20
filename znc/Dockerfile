FROM fedora:22

RUN dnf -y install znc pwgen && dnf clean all
COPY entrypoint.sh /usr/local/bin/entrypoint
RUN chown znc /usr/local/bin/entrypoint && chmod u+x /usr/local/bin/entrypoint

RUN mkdir -p /var/lib/znc/.znc
RUN chown -R znc.znc /var/lib/znc

COPY etc /usr/local/share/znc/templates
RUN chown -R znc.znc /usr/local/share/znc/templates

VOLUME ["/var/lib/znc/.znc/"]
USER znc

EXPOSE 1337

ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD ["znc", "-f"]
