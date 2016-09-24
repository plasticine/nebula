0.5.5
------
#### Changes
* Fix Elixir 1.4 warnings (#56).

0.5.4
------
#### Enhancements
* Add Support to SemaphoreCI (#54).

0.5.3
------
#### Changes
* Make sure additional args can be passed to mix (#50).

0.5.2
------
#### Enhancements
* Add support for minimum coverage (#45).

0.5.1
------
#### Changes
* Fix umbrella source paths in report (#42).

0.5.0
------
#### Enhancements
* Add HTMLCov style reports (#40).
  - Support `mix coveralls.html` task.

0.4.6
------
#### Enhancements
* Add CircleCI integration (#39).
  - Support `mix coveralls.circle` task.

0.4.5
------
#### Changes
* Fix `mix coveralls.post` task error when passing token argument (#38).
  - Use `--token` option for specifying token.

0.4.4
------
#### Enhancements
* Support travis pro (#37).
  - Add `coveralls.travis --pro` option.

0.4.3
------
#### Enhancements
* Add --sha parameter for non-Travis compatibility (#36).

0.4.2
------
#### Changes
* Allow to override coveralls endpoint (#34).

0.4.1
------
#### Changes
* Skip a module without __info__/1 function for avoiding UndefinedFunctionError (#33).

0.4.0
------
#### Enhancements
* Add overall reporting for umbrella project (#23).
   - `mix coveralls --umbrella`
* Add `--verbose` option for printing json when posting to coveralls.io.
   - `mix coveralls.travis --verbose`
* Support specifying test runner in mix.esx (#31).
