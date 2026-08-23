import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Ui

Item {
  id: root

  property var shell: null
  property var manifest: null
  property bool opened: false
  property string sourceText: ""
  property string translation: ""
  property string definition: ""
  property string sourceLanguage: ""
  property string targetLanguage: "en"
  property string monitorName: ""
  property int cursorX: 0
  property int cursorY: 0
  property int duration: 5800

  readonly property int pad: Style.spacing.panelPadding
  readonly property int gap: Style.spacing.md
  readonly property int maxCardWidth: Style.space(430)
  readonly property int minCardWidth: Style.space(250)

  function open(payloadJson) {
    var payload = ({})
    try { payload = JSON.parse(payloadJson || "{}") } catch (e) { return }

    sourceText = String(payload.text || "").slice(0, 500)
    translation = String(payload.translation || "").slice(0, 1200)
    definition = String(payload.definition || "").slice(0, 800)
    var source = String(payload.sourceLanguage || "").slice(0, 16).toLowerCase()
    sourceLanguage = /^[a-z]{2,3}(-[a-z0-9]{2,8})?$/.test(source) ? source : ""
    var target = String(payload.targetLanguage || "en").slice(0, 16).toLowerCase()
    targetLanguage = /^[a-z]{2,3}(-[a-z0-9]{2,8})?$/.test(target) ? target : "en"
    monitorName = payload.monitor || ""
    cursorX = Number(payload.x || 0)
    cursorY = Number(payload.y || 0)
    duration = Number(payload.duration || 5800)
    opened = true
    hideTimer.restart()
  }

  function close() {
    opened = false
    hideTimer.stop()
  }

  Timer {
    id: hideTimer
    interval: Math.max(1000, root.duration)
    onTriggered: root.close()
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: popupWindow
      required property var modelData
      screen: modelData
      visible: root.opened && (!root.monitorName || modelData.name === root.monitorName)
      anchors { top: true; bottom: true; left: true; right: true }
      color: "transparent"
      exclusionMode: ExclusionMode.Ignore
      WlrLayershell.namespace: "panadestein-lexicon"
      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
      mask: Region {}

      BorderSurface {
        id: card
        readonly property int edgeGap: Style.gapsOut
        readonly property int desiredX: root.cursorX + Style.space(14)
        readonly property int desiredY: root.cursorY + Style.space(18)

        width: Math.min(root.maxCardWidth, Math.max(root.minCardWidth, popupWindow.width - edgeGap * 2))
        height: content.implicitHeight + root.pad * 2 + borderTop + borderBottom
        x: Math.max(edgeGap, Math.min(desiredX, popupWindow.width - width - edgeGap))
        y: desiredY + height <= popupWindow.height - edgeGap
          ? desiredY
          : Math.max(edgeGap, root.cursorY - height - Style.space(14))
        color: Util.alpha(Color.background, 0.97)
        borderSpec: Border.surfaceSpec("popups", "border", Color.popups.border, Math.max(1, Style.space(2)))
        radius: Style.cornerRadius

        Column {
          id: content
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.top: parent.top
          anchors.margins: root.pad
          spacing: root.gap

          Text {
            width: parent.width
            text: root.sourceText
            textFormat: Text.PlainText
            color: Color.popups.text
            opacity: 0.62
            font.family: Style.font.family
            font.pixelSize: Style.font.body
            elide: Text.ElideRight
            maximumLineCount: 1
          }

          Text {
            width: parent.width
            text: root.translation
            textFormat: Text.PlainText
            color: Color.popups.text
            font.family: Style.font.family
            font.pixelSize: Style.font.title
            font.bold: true
            wrapMode: Text.Wrap
            maximumLineCount: 3
            elide: Text.ElideRight
          }

          Text {
            visible: root.definition !== ""
            width: parent.width
            text: root.definition
            textFormat: Text.PlainText
            color: Color.popups.text
            opacity: 0.78
            font.family: Style.font.family
            font.pixelSize: Style.font.body
            wrapMode: Text.Wrap
            maximumLineCount: 3
            elide: Text.ElideRight
          }

          Text {
            visible: root.sourceLanguage !== ""
            width: parent.width
            text: root.sourceLanguage.toUpperCase() + "  →  " + root.targetLanguage.toUpperCase()
            textFormat: Text.PlainText
            color: Color.accent
            opacity: 0.8
            font.family: Style.font.family
            font.pixelSize: Style.font.caption
          }
        }
      }
    }
  }
}
