docker-image:
	docker-compose build libswiftnav

docker: docker-image
	docker-compose run libswiftnav

docker-build: docker-image
	mkdir -p build
	docker-compose run -T libswiftnav /bin/bash -c "cd build && cmake .. && make -j4"

docker-lint: docker-image
	mkdir -p build
	docker-compose run -T libswiftnav /bin/bash -c "cd build && cmake .. && make -j4 clang-format-all"

do-all-unit-tests:
	bazel test --test_tag_filters=unit --test_output=all //...

do-all-integration-tests:
	bazel test --test_tag_filters=integration --test_output=all //...

clang-format-all-check:
	bazel build //... --config=clang-format-check

clang-format-all:
	bazel run @rules_swiftnav//clang_format

clang-tidy-all-check:
	bazel build //... --config=clang-tidy

do-code-coverage:
	bazel coverage --test_tag_filters=unit --collect_code_coverage --combined_report=lcov //...

do-generate-coverage-report: do-code-coverage
	genhtml bazel-out/_coverage/_coverage_report.dat -o coverage

gen-compile-commands:
	bazel run //:gen_compile_commands
