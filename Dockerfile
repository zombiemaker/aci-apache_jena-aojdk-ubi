FROM zmaker123/dci-aojdk_hotspot-ubi:8.2-14-latest

WORKDIR /
COPY README.md entrypoint.sh image-info ./
ENTRYPOINT ["entrypoint.sh"]
CMD ["default"]