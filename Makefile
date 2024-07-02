TARGET = StarlingRoundUp
TEST_TARGET = StarlingRoundUpTests
UI_TEST_TARGET = StarlingRoundUpUITests

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
	set -o pipefail && NSUnbufferedIO=YES xcodebuild clean build -scheme $(TARGET) -destination $(IOS_DESTINATION)

.PHONY: test
test:
	set -o pipefail && NSUnbufferedIO=YES xcodebuild clean build-for-testing -scheme $(TARGET) -only-testing $(TEST_TARGET) -destination $(IOS_DESTINATION)
	set -o pipefail && NSUnbufferedIO=YES xcodebuild test-without-building -scheme $(TARGET) -only-testing $(TEST_TARGET) -destination $(IOS_DESTINATION)

.PHONY: test
uitest:
	set -o pipefail && NSUnbufferedIO=YES xcodebuild clean build-for-testing -scheme $(TARGET) -only-testing $(UI_TEST_TARGET) -destination $(IOS_DESTINATION)
	set -o pipefail && NSUnbufferedIO=YES xcodebuild test-without-building -scheme $(TARGET) -only-testing $(UI_TEST_TARGET) -destination $(IOS_DESTINATION)
