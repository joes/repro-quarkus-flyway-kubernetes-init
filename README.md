# repro-flyway-init

Reproduces:

 * flyway is not setting `Deployment.spec.template.spec.serviceAccountName` such that its RoleBinding can be applied
 * flyway is not setting `imagePullSecrets` in the flyway init job spec according to the imagePullSecrets used by the Deployment

 ## Steps to reproduce

 Build:

 ```bash
 ./mvnw clean package -Dquarkus.container-image.group="some-registry.com" -Dquarkus.container-image.tag="latest"
 ```

 Check the generated yaml in `target/kubernetes/kubernetes.yml` for serviceAccountName and imagePullSecrets for the flyway job.

 No serviceAccountName is set:

 ```bash
 cat target/kubernetes/kubernetes.yml | grep serviceAccountName
 ```
 
No match found.

Check imagePullSecrets set for job (requires https://github.com/mikefarah/yq):

 ```bash
  yq 'select(.kind=="Job")' target/kubernetes/kubernetes.yml | grep -A1 -i "imagePullSecrets"
```

No match found.

## Expected behavior

The `Deployment` in the generated yaml should have the `serviceAccountName` set to the one found in the `RoleBinding` and the `imagePullSecrets` of the flyway job set to the secrets used by the Deployment.

The serviceAccountName is set correctly in Deployment if the extension "kubernetes-client" is introduced:

```xml
<dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-kubernetes-client</artifactId>
</dependency>
```
