# WK Cliente

MVP do aplicativo do Grupo WK para clientes da rede de postos.

## Estado atual

Primeira versão funcional da interface em Flutter com dados de demonstração e navegação entre:

- Splash
- Login
- Cadastro
- Início
- Benefícios e cupons
- Promoções
- Postos
- Perfil e histórico

A identidade visual segue os mockups aprovados: fundo azul-marinho/preto, azul elétrico, vermelho WK, cartões escuros e tipografia clara.

## Executar

Este repositório contém o código Flutter do aplicativo. Se as pastas de plataforma ainda não existirem no seu computador, rode uma vez:

```bash
flutter create . --platforms=android
flutter pub get
flutter run
```

Depois disso, os arquivos `lib/` permanecem como a implementação do WK Cliente.

## Próximas etapas

- Firebase Authentication
- Cloud Firestore
- QR Code real do cliente
- Cupons persistentes
- Localização real dos postos
- Integração com WK Operação / PDV / ERP
