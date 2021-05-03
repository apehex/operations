# Disabling WebRTC

Firefox / Chrome may leak IP.

## Checking

[Browser-leaks][browser-leaks]

## Firefox

- about:config
- set `media.peerconnection.enabled` to `false`

## Chrome

Install an extension.

[browser-leaks]: https://browserleaks.com/webrtc
