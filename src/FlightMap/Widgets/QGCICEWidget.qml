/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


/**
 * @file
 *   @brief QGC Attitude Instrument
 *   @author Gus Grubba <mavlink@grubba.com>
 */

import QtQuick              2.3
import QtGraphicalEffects   1.0

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Palette       1.0

Item {
    id: root

    property bool showPitch:    true
    property var  vehicle:      null
    property real size
    property bool showHeading:  false
    property bool temperature_widget:  true

    property real _rollAngle:   vehicle ? vehicle.roll.rawValue  : 0
    property real _pitchAngle:  vehicle ? vehicle.pitch.rawValue : 0

    property real _iceTemp:   vehicle ? vehicle.ice.iceTemp.rawValue  : 0
    property real _genTemp:  vehicle ? vehicle.ice.genTemp.rawValue : 0
    property real _rpm:  vehicle ? vehicle.ice.rpm.rawValue : 0

    width:  size
    height: size

    QGCPalette { id: qgcPal; colorGroupEnabled: enabled }

    Item {
        id:             instrument
        anchors.fill:   parent
        visible:        false
        //----------------------------------------------------
        //-- Pointer
        Image {
            id:                 pointer
            source:             "/qmlimages/attitudePointer.svg"
            mipmap:             true
            fillMode:           Image.PreserveAspectFit
            anchors.fill:       parent
            sourceSize.height:  parent.height
            transform: Rotation {
                origin.x:       root.width  / 2
                origin.y:       root.height / 2
                angle:          temperature_widget ? -45+_iceTemp/200*90 : -45+_rpm/9000*90
            }
        }
        //-- Pointer2
        Image {
            id:                 pointer2
            source:             "/qmlimages/attitudePointer.svg"
            mipmap:             true
            fillMode:           Image.PreserveAspectFit
            anchors.fill:       parent
            sourceSize.height:  parent.height
            visible:        temperature_widget
            transform: Rotation {
                origin.x:       root.width  / 2
                origin.y:       root.height / 2
                angle:          45-_genTemp/200*90-180
            }
        }
        //----------------------------------------------------
        //-- Instrument Dial
        Image {
            id:                 instrumentDial
            source:             "/qmlimages/attitudeDial.svg"
            mipmap:             true
            fillMode:           Image.PreserveAspectFit
            anchors.fill:       parent
            sourceSize.height:  parent.height
        }
        //-- Instrument Dial2
        Image {
            id:                 instrumentDial2
            source:             "/qmlimages/attitudeDial.svg"
            mipmap:             true
            fillMode:           Image.PreserveAspectFit
            anchors.fill:       parent
            sourceSize.height:  parent.height
            transform: Rotation {
                origin.x:       root.width  / 2
                origin.y:       root.height / 2
                angle:          -180
            }
            visible:        temperature_widget
        }
        //----------------------------------------------------
        //-- Pitch
        /*QGCPitchIndicator {
            id:                 pitchWidget
            visible:            root.showPitch
            size:               root.size * 0.5
            anchors.verticalCenter: parent.verticalCenter
            pitchAngle:         _pitchAngle
            rollAngle:          _rollAngle
            color:              Qt.rgba(0,0,0,0)
        }*/
    }

    Rectangle {
        id:             mask
        anchors.fill:   instrument
        radius:         width / 2
        color:          "black"
        visible:        false
    }

    OpacityMask {
        anchors.fill: instrument
        source: instrument
        maskSource: mask
    }

    Rectangle {
        id:             borderRect
        anchors.fill:   parent
        radius:         width / 2
        color:          Qt.rgba(0,0,0,0)
        border.color:   qgcPal.text
        border.width:   1
    }

    QGCLabel {
        anchors.bottomMargin:       Math.round(ScreenTools.defaultFontPixelHeight * .75)
        anchors.bottom:             parent.bottom
        anchors.horizontalCenter:   parent.horizontalCenter
        text:                       _headingString3
        color:                      "white"
        visible:                    showHeading

        property string _headingString: vehicle ? vehicle.heading.rawValue.toFixed(0) : "OFF"
        property string _headingString2: _headingString.length === 1 ? "0" + _headingString : _headingString
        property string _headingString3: _headingString2.length === 2 ? "0" + _headingString2 : _headingString2
    }
}
