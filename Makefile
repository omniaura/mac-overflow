.PHONY: build run clean release app dmg install uninstall test

build:
	swift build

run: build
	.build/debug/MacOverflow

clean:
	swift package clean
	rm -rf .build build

release:
	swift build -c release --arch arm64 --arch x86_64

app: release
	@echo "Creating app bundle..."
	@mkdir -p build/MacOverflow.app/Contents/MacOS
	@mkdir -p build/MacOverflow.app/Contents/Resources
	@cp .build/release/MacOverflow build/MacOverflow.app/Contents/MacOS/
	@./scripts/generate-info-plist.sh > build/MacOverflow.app/Contents/Info.plist
	@echo "App bundle created at build/MacOverflow.app"

dmg: app
	@echo "Creating DMG..."
	@command -v create-dmg >/dev/null 2>&1 || brew install create-dmg
	@create-dmg \
		--volname "Mac Overflow" \
		--window-pos 200 120 \
		--window-size 600 400 \
		--icon-size 100 \
		--icon "MacOverflow.app" 175 120 \
		--hide-extension "MacOverflow.app" \
		--app-drop-link 425 120 \
		"build/MacOverflow.dmg" \
		"build/MacOverflow.app" 2>/dev/null || \
	hdiutil create -volname "Mac Overflow" -srcfolder build/MacOverflow.app -ov -format UDZO "build/MacOverflow.dmg"
	@echo "DMG created at build/MacOverflow.dmg"

install: app
	@echo "Installing Mac Overflow..."
	@rm -rf /Applications/MacOverflow.app
	@cp -r build/MacOverflow.app /Applications/
	@echo "Installed to /Applications/MacOverflow.app"

uninstall:
	@echo "Uninstalling Mac Overflow..."
	@rm -rf /Applications/MacOverflow.app
	@echo "Uninstalled"

test:
	swift test
