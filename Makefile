SCHEME = StarlingRoundUp
TEST_PLAN = StarlingRoundUp
UI_TEST_PLAN = StarlingRoundUpUI

IOS_DESTINATION = 'platform=iOS Simulator,name=iPhone 15,OS=17.5'

.PHONY: clean
clean:
	xcodebuild clean

.PHONY: format
format:
	swiftlint --fix
	swiftformat .

.PHONY: lint
lint:
	swiftlint --strict
	swiftformat --lint .

.PHONY: build
build:
	set -o pipefail && NSUnbufferedIO=YES xcodebuild clean build -scheme $(SCHEME) -destination $(IOS_DESTINATION) | xcbeautify

.PHONY: test
test:
	set -o pipefail && NSUnbufferedIO=YES xcodebuild clean build-for-testing -scheme $(SCHEME) -destination $(IOS_DESTINATION) -testPlan $(TEST_PLAN) | xcbeautify
	set -o pipefail && NSUnbufferedIO=YES xcodebuild test-without-building -scheme $(SCHEME) -destination $(IOS_DESTINATION) -testPlan $(TEST_PLAN) | xcbeautify

.PHONY: uitest
uitest:
	set -o pipefail && NSUnbufferedIO=YES xcodebuild clean build-for-testing -scheme $(SCHEME) -destination $(IOS_DESTINATION) -testPlan $(UI_TEST_PLAN) | xcbeautify
	set -o pipefail && NSUnbufferedIO=YES xcodebuild test-without-building -scheme $(SCHEME) -destination $(IOS_DESTINATION) -testPlan $(UI_TEST_PLAN) | xcbeautify
