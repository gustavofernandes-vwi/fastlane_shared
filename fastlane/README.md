fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

### version

```sh
[bundle exec] fastlane version
```

Exibe o código e nome de versão atual do app, conforme pubspec.yaml

### make_changelog

```sh
[bundle exec] fastlane make_changelog
```



### download_jira_notes

```sh
[bundle exec] fastlane download_jira_notes
```



### download_notion_notes

```sh
[bundle exec] fastlane download_notion_notes
```



### last_commit

```sh
[bundle exec] fastlane last_commit
```

Exibe a data e a timestamp do último commit

### create_changelog_files

```sh
[bundle exec] fastlane create_changelog_files
```

Cria os arquivos de changelog para serem preenchidos

O conteúdo desses arquivos serão usados na hora de subir as builds

### beta_all

```sh
[bundle exec] fastlane beta_all
```

Gera as builds **Beta** para ambas as plataformas e faz upload para as ferramentas de distribuição correspondentes.

Também cria a release no GitHub e gera builds executáveis (apk do android) para anexar na release.

Esta é a lane de mais alto nível, que chama outras lanes para que tudo que precisa ser feito aconteça com um único comando.

O tempo de execução dessa lane é altamente elevado.

### prod_all

```sh
[bundle exec] fastlane prod_all
```

Gera as builds de **produção** para ambas as plataformas e faz upload para as ferramentas de distribuição correspondentes.

Também cria a release no GitHub e gera builds executáveis (apk do android) para anexar na release.

Esta é a lane de mais alto nível, que chama outras lanes para que tudo que precisa ser feito aconteça com um único comando.

O tempo de execução dessa lane é altamente elevado.

### alpha_all

```sh
[bundle exec] fastlane alpha_all
```

Gera as builds **alpha** para ambas as plataformas e faz upload para as ferramentas de distribuição correspondentes.

As builds são numeradas automaticamente de acordo com o último commit e também são liberadas automaticamente

### beta_github_release

```sh
[bundle exec] fastlane beta_github_release
```

Cria a release no GitHub e gera builds executáveis (apk do android) para anexar na release.

### prod_github_release

```sh
[bundle exec] fastlane prod_github_release
```

Cria a release no GitHub e gera builds executáveis (apk do android) para anexar na release.

----


## iOS

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Gera a build **beta** do iOS e faz upload para o AppStore Connect (TestFlight)

### ios release_beta

```sh
[bundle exec] fastlane ios release_beta
```



### ios prod

```sh
[bundle exec] fastlane ios prod
```

Gera a build de **produção** do iOS e faz upload para o AppStore Connect (TestFlight)

### ios submit_to_review

```sh
[bundle exec] fastlane ios submit_to_review
```



### ios alpha

```sh
[bundle exec] fastlane ios alpha
```



### ios release_alpha

```sh
[bundle exec] fastlane ios release_alpha
```



### ios prepare_certificates

```sh
[bundle exec] fastlane ios prepare_certificates
```



----


## Android

### android beta

```sh
[bundle exec] fastlane android beta
```

Gera o appbundle do **beta** para Android e faz upload para o Google Play Console

### android release_beta

```sh
[bundle exec] fastlane android release_beta
```



### android prod

```sh
[bundle exec] fastlane android prod
```

Gera o appbundle da **produção** para Android

### android alpha

```sh
[bundle exec] fastlane android alpha
```



### android release_alpha

```sh
[bundle exec] fastlane android release_alpha
```



### android beta_for_github

```sh
[bundle exec] fastlane android beta_for_github
```



### android prod_for_github

```sh
[bundle exec] fastlane android prod_for_github
```



----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
