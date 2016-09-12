# QingDistrict

[![Latest Version](https://img.shields.io/npm/v/qing-district.svg)](https://www.npmjs.com/package/qing-district)
[![Build Status](https://img.shields.io/travis/mycolorway/qing-district.svg)](https://travis-ci.org/mycolorway/qing-district)
[![Coveralls](https://img.shields.io/coveralls/mycolorway/qing-district.svg)](https://coveralls.io/github/mycolorway/qing-district)
[![David](https://img.shields.io/david/mycolorway/qing-district.svg)](https://david-dm.org/mycolorway/qing-district)
[![David](https://img.shields.io/david/dev/mycolorway/qing-district.svg)](https://david-dm.org/mycolorway/qing-district#info=devDependencies)

QingDistrict is a ui component inherited from QingModule.

## Usage

```html
<script type="text/javascript" src="node_modules/jquery/dist/jquery.js"></script>
<script type="text/javascript" src="node_modules/qing-module/dist/qing-module.js"></script>
<script type="text/javascript" src="node_modules/qing-district/dist/qing-district.js"></script>

<div class="your-element">
    <input type="hidden" name="province" data-province-field value="110000" />
    <input type="hidden" name="city" data-city-field value ="110100" />
    <input type="hidden" name="county" data-county-field value= "110105" />
</div>
```

QingDistrict will set and get value from `data-[type]-field` elements, there are required.

```js
var qingDistrict = new QingDistrict({
  el: '.your-element',
  dataSource: function (callback) {
    callback([
        {name: "one", code: "123456", cities: [
            name: "city one", code: "city-12345", counties: [{}]
        ]},
        {name: "two", code: "45678", cities: [
        ]}
    ])
  }
});

qingDistrict.on('ready', function(e) {
  // do something
});
```

## Options

__el__

Selector/Element/jQuery Object, required, specify the html element.

## Methods

__destroy__ ()

Destroy component, restore element to original state.

## Events

__ready__ (event)

Triggered after initialization.

## Installation

Install via npm:

```bash
npm install --save qing-district
```

## Development

Clone repository from github:

```bash
git clone https://github.com/mycolorway/qing-district.git
```

Install npm dependencies:

```bash
npm install
```

Run default gulp task to build project, which will compile source files, run test and watch file changes for you:

```bash
gulp
```

Now, you are ready to go.

## Publish

When you want to publish new version to npm and bower, please make sure all tests have passed, and you need to do these preparations:

* Add release information in `CHANGELOG.md`. The format of markdown contents will matter, because build scripts will get version and release content from the markdown file by regular expression. You can follow the format of the older releases.

* Put your [personal API tokens](https://github.com/blog/1509-personal-api-tokens) in `/.token.json`(listed in `.gitignore`), which is required by the build scripts to request [Github API](https://developer.github.com/v3/) for creating new release:

```json
{
  "github": "[your github personal access token]"
}
```

Now you can run `gulp publish` task, which will do these work for you:

* Get version number from `CHANGELOG.md` and bump it into `package.json` and `bower.json`.
* Get release information from `CHANGELOG.md` and request Github API to create new release.

If everything goes fine, you can see your release at [https://github.com/mycolorway/qing-district/releases](https://github.com/mycolorway/qing-district/releases). At the End you can publish new version to npm with the command:

```bash
npm publish
```

Please be careful with the last step, because you cannot delete or republish a version on npm.
