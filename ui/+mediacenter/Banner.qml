/*
 *  Copyright 2018 by Aditya Mehra <aix.m@outlook.com>
 */

import QtQuick.Layouts 1.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.kirigami 2.19 as Kirigami
import Mycroft 1.0 as Mycroft
import Qt5Compat.GraphicalEffects
import "code/helper.js" as HelperJS

Item {
    id: bannerRoot
    property alias title: bannerTitle.text
    property alias source: bannerImage.source
    property alias titleWrapMode: bannerTitle.wrapMode
    property alias titleLevel: bannerTitle.level
    property alias radius: imgRoot.radius

    Rectangle {
        id: imgRoot
        color: "transparent"
        clip: true
        anchors.fill: parent
        anchors.topMargin: 1
        anchors.leftMargin: 1
        anchors.rightMargin: 1
        anchors.bottomMargin: 0
        radius: bannerRoot.radius
        
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                x: imgRoot.x; y: imgRoot.y
                width: imgRoot.width
                height: imgRoot.height
                radius: imgRoot.radius
            }
        }

        Image {
            id: bannerImage
            width: parent.width
            height: parent.height
            y: -12
            opacity: 1
            fillMode: Image.PreserveAspectCrop

            Rectangle {
                id: bannerOverlay
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.height * 0.3
                color: Kirigami.Theme.backgroundColor
                opacity: 0.8

                Kirigami.Heading {
                    id: bannerTitle
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                    level: 2
                    maximumLineCount: 2
                    color: Kirigami.Theme.textColor
                }
            }
        }
    }
}