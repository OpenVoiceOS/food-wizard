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

import QtQuick.Layouts 1.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.kirigami 2.19 as Kirigami
import Mycroft 1.0 as Mycroft
import Qt5Compat.GraphicalEffects

import "code/helper.js" as HelperJS

Mycroft.Delegate {
    id: root
    skillBackgroundSource: "https://source.unsplash.com/1920x1080/?+food"
    property bool compactMode: parent.height >= 550 ? 0 : 1
    fillWidth: true

    background: Item {
        anchors.fill: parent
        z: -1

        Kirigami.Icon {
           anchors.bottom: parent.bottom
           anchors.bottomMargin: 16
           anchors.right: parent.right
           width: 60
           height: 150
           opacity: 0.85
           source: HelperJS.isLight(Kirigami.Theme.backgroundColor) ? Qt.resolvedUrl("images/edamam-dark-vertical.svg") : Qt.resolvedUrl("images/edamam-light-vertical.svg")
        }
    }
    
    Component.onCompleted: {
        uiGridView.forceActiveFocus()
    }
    
    Keys.onBackPressed: {
        parent.parent.parent.currentIndex--
        parent.parent.parent.currentItem.contentItem.forceActiveFocus()
    }
    
    GridView {
        id: uiGridView
        anchors.fill: parent
        cacheBuffer: width
        property int columns: {
            var width = parent.width
            if (width >= 1920) {
                return 4
            } else if (width >= 1366) {
                return 3
            } else if (width >= 1024) {
                return 2
            } else {
                return 1
            }
        }
        cellWidth: parent.width / columns
        cellHeight: Kirigami.Units.gridUnit * 12
        model: sessionData.recipeBlob.hits
        keyNavigationEnabled: true
        highlightFollowsCurrentItem: true
        ScrollBar.vertical: ScrollBar {}
        
        delegate: Item {
            id: cardRoot
            width: uiGridView.cellWidth
            height: uiGridView.cellHeight

            ItemDelegate {
                id: card
                width: uiGridView.cellHeight + Kirigami.Units.gridUnit
                height: uiGridView.cellHeight - Kirigami.Units.gridUnit
                anchors.centerIn: parent

                background: Rectangle {
                    id: cardBackground
                    color: Kirigami.Theme.backgroundColor
                    radius: Kirigami.Units.largeSpacing / 2
                    border.color: Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.5)
                    border.width: 1
                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 0
                        verticalOffset: 0
                        radius: 10
                        samples: 16
                        color: Qt.rgba(0, 0, 0, 0.5)
                    }
                }

                ColumnLayout {
                    anchors.fill: parent

                    Banner {
                        id: bannerImage
                        title: modelData.recipe.label
                        source: modelData.recipe.image
                        titleWrapMode: Text.WordWrap
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: cardBackground.radius
                    }

                    Label {
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                        Layout.preferredHeight: Mycroft.Units.gridUnit * 2
                        Layout.leftMargin: Mycroft.Units.gridUnit / 2
                        Layout.rightMargin: Mycroft.Units.gridUnit / 2
                        Layout.bottomMargin: Mycroft.Units.gridUnit / 2
                        Layout.topMargin: -Mycroft.Units.gridUnit / 2                     
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        text: modelData.recipe.source
                        font.pixelSize: parent.width * 0.07
                        color: Kirigami.Theme.textColor
                    }
                }

                onClicked: {
                    var RecipeUrl = modelData.recipe.url;
                    Mycroft.SoundEffects.playClickedSound(Qt.resolvedUrl("sound/clicked.wav"))
                    triggerGuiEvent("foodwizard.showrecipe", {"recipe": RecipeUrl});
                }

                Keys.onReturnPressed: {
                    clicked()
                }
                
                Rectangle {
                    anchors.fill: parent
                    visible: cardRoot.activeFocus ? 1 : 0
                    color: Qt.rgba(0, 0, 3, 0.2)
                }
            }

            Keys.onReturnPressed: {
                card.clicked()
            }
        }
    }

    Kirigami.Heading {
        text: qsTr("No recipes found")
        parent: root
        anchors.centerIn: parent
        visible: uiGridView.count == 0
    }
}
