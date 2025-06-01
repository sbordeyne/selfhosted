ARG KC_VERSION

FROM quay.io/keycloak/keycloak:${KC_VERSION} as builder

ENV KC_CACHE=local
ENV KC_DB=postgres
ENV KC_TRANSACTION_XA_ENABLED=true
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

WORKDIR /opt/keycloak

RUN /opt/keycloak/bin/kc.sh build --features="docker"

FROM quay.io/keycloak/keycloak:${KC_VERSION}
COPY --from=builder /opt/keycloak/ /opt/keycloak/
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
