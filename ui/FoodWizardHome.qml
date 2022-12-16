/*
 *  Copyright 2018 by Aditya Mehra <aix.m@outlook.com>
 *  Copyright 2018 Marco Martin <mart@kde.org>
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick.Layouts 1.4
import QtQuick 2.8
import QtQuick.Controls 2.2
import org.kde.kirigami 2.10 as Kirigami
import Mycroft 1.0 as Mycroft
import QtGraphicalEffects 1.0
import "code/helper.js" as HelperJS

Mycroft.Delegate {
    id: root
    skillBackgroundSource: "https://source.unsplash.com/1920x1080/?+food"
    property bool compactMode: parent.height >= 550 ? 0 : 1
    property bool horizontalMode: width > height ? 1 : 0   
    fillWidth: true

    Kirigami.Icon {
        anchors.bottom: parent.bottom 
        anchors.horizontalCenter: parent.horizontalCenter
        width: 150
        height: 60
        opacity: 0.7
        source: HelperJS.isLight(Kirigami.Theme.backgroundColor) ? Qt.resolvedUrl("images/edamam-dark.svg") : Qt.resolvedUrl("images/edamam-light.svg")
    }

    Component.onCompleted: {
        txtFld.forceActiveFocus()
    }

    Item {
        anchors.fill: parent

        ColumnLayout {
            width: parent.width
            height: parent.height / 2
            anchors.verticalCenter: compactMode ? undefined : parent.verticalCenter
            anchors.top: compactMode ? parent.top : undefined
            spacing: Kirigami.Units.largeSpacing

            Rectangle {
                id: heads
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.maximumHeight: Mycroft.Units.gridUnit * 6
                Layout.minimumHeight: Mycroft.Units.gridUnit * 4
                radius: 10
                color: Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.9)

                Image {
                    id: headsImage
                    anchors.left: parent.left
                    anchors.leftMargin: Mycroft.Units.gridUnit / 2
                    anchors.verticalCenter: parent.verticalCenter
                    width: Mycroft.Units.gridUnit * 2
                    height: Mycroft.Units.gridUnit * 2
                    source: Qt.resolvedUrl("images/foodwizz.png")
                }

                Label {
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    text: "Find Something To Cook With Custom Ingredients"
                    anchors.left: headsImage.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: closeBtn.left
                    anchors.margins: Mycroft.Units.gridUnit / 2
                    wrapMode: Text.WordWrap
                    fontSizeMode: Text.Fit
                    font.pixelSize: heads.height * 0.25
                    minimumPixelSize: 10
                    color: Kirigami.Theme.textColor
                }

                Button {
                    id: closeBtn
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.margins: 4
                    width: height
                    KeyNavigation.up: answerButton
                    KeyNavigation.down: txtFld
                    
                    background: Rectangle {
                        color: "transparent"
                        border.color: closeBtn.activeFocus ? Kirigami.Theme.linkColor : "transparent"
                        border.width: 2
                        radius: 3
                    }

                    contentItem: Item {
                        Kirigami.Icon {
                            anchors.centerIn: parent
                            width: parent.width * 0.9
                            height: parent.height * 0.9
                            source: "window-close"
                            color: Kirigami.Theme.textColor

                            ColorOverlay {
                                anchors.fill: parent
                                source: parent
                                color: closeBtn.activeFocus ? Kirigami.Theme.linkColor : Kirigami.Theme.textColor
                            }
                        }
                    }

                    Keys.onReturnPressed: {
                        Mycroft.SoundEffects.playClickedSound(Qt.resolvedUrl("sound/clicked.wav"))
                        triggerGuiEvent("foodwizard.close", {})
                    }

                    onClicked: {
                        Mycroft.SoundEffects.playClickedSound(Qt.resolvedUrl("sound/clicked.wav"))
                        triggerGuiEvent("foodwizard.close", {})
                    }
                }
            }
            
            Rectangle {
                id: txtFld
                anchors.top: sep.bottom
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.maximumHeight: Mycroft.Units.gridUnit * 8
                Layout.minimumHeight: Mycroft.Units.gridUnit * 5
                color: "transparent"
                border.width: 2
                radius: Kirigami.Units.smallSpacing
                border.color: txtFld.activeFocus ? Kirigami.Theme.linkColor : "transparent"
                KeyNavigation.down: answerButton
                KeyNavigation.up: closeBtn
                focus: true

                Keys.onReturnPressed: { 
                    txtFldInternal.forceActiveFocus()
                }
                
                TextField {
                    id: txtFldInternal
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.largeSpacing
                    KeyNavigation.down: answerButton
                    font.pixelSize: txtFld.height * 0.25
                    placeholderText: "Add a list of ingredients e.g., orange, cheese, chicken, lime"

                    onAccepted: {
                        Mycroft.SoundEffects.playClickedSound(Qt.resolvedUrl("sound/clicked.wav"))
                        triggerGuiEvent("foodwizard.searchrecipe", {"query": txtFldInternal.text})
                    }
                    Keys.onReturnPressed: {
                        Mycroft.SoundEffects.playClickedSound(Qt.resolvedUrl("sound/clicked.wav"))
                        triggerGuiEvent("foodwizard.searchrecipe", {"query": txtFldInternal.text})
                    }
                }
            }
            
            Button {
                id: answerButton
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.maximumHeight: Mycroft.Units.gridUnit * 6
                Layout.minimumHeight: Mycroft.Units.gridUnit * 4
                Layout.margins: Kirigami.Units.gridUnit
                KeyNavigation.up: txtFld
                
                background: Rectangle {
                    color: answerButton.activeFocus ? "#4169E1" : "#4124AA" 
                    radius: Kirigami.Units.gridUnit
                }

                contentItem: Item {
                    Kirigami.Heading {
                        anchors.centerIn: parent
                        text: qsTr("Find Recipes")
                        level: compactMode ? 3 : 1
                    }
                }

                onClicked: {
                    Mycroft.SoundEffects.playClickedSound(Qt.resolvedUrl("sound/clicked.wav"))
                    triggerGuiEvent("foodwizard.searchrecipe", {"query": txtFldInternal.text})
                }

                onPressed: {
                    answerButton.opacity = 0.5
                }

                onReleased: {
                    answerButton.opacity = 1
                }

                Keys.onReturnPressed: {
                    clicked()
                }
            }
        }
    }
}
