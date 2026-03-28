# bpmn-js-rails example app

This example app mounts the engine and exercises BPMN, DMN, and form editors/viewers.

## Setup

```bash
bundle install
yarn install
yarn build
bundle exec rails db:prepare
bundle exec rails server
```

## Development workflow

In one terminal, keep engine bundles up to date:

```bash
yarn build:watch
```

In another terminal, run the example app:

```bash
bundle exec rails server
```

## Notes

- This engine now uses esbuild + importmap for JavaScript delivery.
- Legacy UMD assets are not used.
- If you update files in `app/javascript/bpmn_js_rails/entrypoints`, rebuild with `yarn build` before testing or releasing.
