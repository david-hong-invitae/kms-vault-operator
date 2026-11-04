# Repackage patoarvizu/kms-vault-operator:v0.16.0 with a clean base image.
#
# The original base (gcr.io/distroless/static-debian10) contained eMudhra
# intermediate CA roots (emSign ECC Root CA - G3, AAA Certificate Services)
# disclosed as compromised on 17-20 Oct 2026.
#
# The operator binary is CGO_ENABLED=0 (fully static) so no rebuild from
# source is needed — we copy the binaries into a clean distroless base.
#
# gcr.io/distroless/static:nonroot verified clean: 148 certs, 0 eMudhra roots.
# See DATA-9395: https://invitae.jira.com/browse/DATA-9395
FROM patoarvizu/kms-vault-operator:v0.16.0 AS source
FROM gcr.io/distroless/static:nonroot
COPY --from=source /manager /manager
COPY --from=source /kms-vault-validating-webhook /kms-vault-validating-webhook
USER nonroot:nonroot
ENTRYPOINT ["/manager"]
