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
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0
import QGroundControl.Palette       1.0

Rectangle {
    height: 250
    width:  pageWidth
    color:          qgcPal.window
   // property alias  guidedController:   flightMap.guidedActionsController

    property var    _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle ? QGroundControl.multiVehicleManager.activeVehicle : QGroundControl.multiVehicleManager.offlineEditingVehicle
    property real   _defaultSize:       ScreenTools.defaultFontPixelHeight * (9)
    property real   _sizeRatio:         ScreenTools.isTinyScreen ? (width / _defaultSize) * 0.5 : width / _defaultSize
    property real   _labelFontSize:     ScreenTools.defaultFontPointSize * 0.75 * _sizeRatio

    property real _rollAngle:   _activeVehicle ? _activeVehicle.roll.rawValue  : 0
    property real _pitchAngle:  _activeVehicle ? _activeVehicle.pitch.rawValue : 0

    property real _iceTemp:   _activeVehicle ? _activeVehicle.ice.iceTemp.rawValue  : 0
    property real _genTemp:  _activeVehicle ? _activeVehicle.ice.genTemp.rawValue : 0
    property real _rpm:  _activeVehicle ? _activeVehicle.ice.rpm.rawValue : 0

    property real _cooler:   _activeVehicle ? _activeVehicle.ice.cooler.rawValue  : 0
    property real _starter:  _activeVehicle ? _activeVehicle.ice.starter.rawValue : 0
    property real _throttle:  _activeVehicle ? _activeVehicle.ice.throttle.rawValue : 0

    Item {
        id: root_pwm1
        anchors.right:       parent.horizontalCenter
        anchors.rightMargin:  ScreenTools.defaultFontPixelHeight / 4

        property bool showPitch:    true
        property var  vehicle:      _activeVehicle
        property real size
        property bool showHeading:  false
        property bool temperature_widget:  true

        width:  parent.width/2 - ScreenTools.defaultFontPixelHeight / 4
        height: parent.width/2 - ScreenTools.defaultFontPixelHeight / 4

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
                        origin.x:       root_pwm1.width  / 2
                        origin.y:       root_pwm1.height / 2
                        angle:          -45+_cooler/100*90
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
                    visible:        false
                    transform: Rotation {
                        origin.x:       root_pwm1.width  / 2
                        origin.y:       root_pwm1.height / 2
                        //angle:          45-_genTemp/200*90-180
                        angle:          -45+_cooler/100*90
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
                        origin.x:       root_pwm1.width  / 2
                        origin.y:       root_pwm1.height / 2
                        angle:          -180
                    }
                    visible:        false
                }

                Rectangle {
                    anchors.centerIn:   parent
                    width:              size * 0.001
                    height:             size * 0.001
                    opacity:            1

                    QGCLabel {
                        text:               "Cooler"
                        anchors.bottomMargin:       1
                        //font.family:        _activeVehicle ? ScreenTools.demiboldFontFamily : ScreenTools.normalFontFamily
                        font.pointSize:     12
                        color:              "red"
                        anchors.centerIn:   parent
                       }

                }
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
            border.width:   1
        }
    }

    Item {
        id: root_pwm2
        anchors.left:       parent.horizontalCenter
        anchors.leftMargin:  ScreenTools.defaultFontPixelHeight / 4
        property bool showPitch:    true
        property var  vehicle:      _activeVehicle
        property real size
        property bool showHeading:  false
        property bool temperature_widget:  true

        width:  parent.width/2 - ScreenTools.defaultFontPixelHeight / 4
        height: parent.width/2 - ScreenTools.defaultFontPixelHeight / 4

        Item {
                id:             sinstrument
                anchors.fill:   parent
                visible:        false
                //----------------------------------------------------
                //-- Pointer
                Image {
                    id:                 spointer
                    source:             "/qmlimages/attitudePointer.svg"
                    mipmap:             true
                    fillMode:           Image.PreserveAspectFit
                    anchors.fill:       parent
                    sourceSize.height:  parent.height
                    transform: Rotation {
                        origin.x:       root_pwm2.width  / 2
                        origin.y:       root_pwm2.height / 2
                        angle:          -45+_starter/100*90
                    }
                }
                //-- Pointer2
                Image {
                    id:                 spointer2
                    source:             "/qmlimages/attitudePointer.svg"
                    mipmap:             true
                    fillMode:           Image.PreserveAspectFit
                    anchors.fill:       parent
                    sourceSize.height:  parent.height
                    visible:        true
                    transform: Rotation {
                        origin.x:       root_pwm2.width  / 2
                        origin.y:       root_pwm2.height / 2
                        //angle:          45-_genTemp/200*90-180
                        angle:          45-_throttle/100*90-180
                    }
                }
                //----------------------------------------------------
                //-- Instrument Dial
                Image {
                    id:                 sinstrumentDial
                    source:             "/qmlimages/attitudeDial.svg"
                    mipmap:             true
                    fillMode:           Image.PreserveAspectFit
                    anchors.fill:       parent
                    sourceSize.height:  parent.height
                }
                //-- Instrument Dial2
                Image {
                    id:                 sinstrumentDial2
                    source:             "/qmlimages/attitudeDial.svg"
                    mipmap:             true
                    fillMode:           Image.PreserveAspectFit
                    anchors.fill:       parent
                    sourceSize.height:  parent.height
                    transform: Rotation {
                        origin.x:       root_pwm2.width  / 2
                        origin.y:       root_pwm2.height / 2
                        angle:          -180
                    }
                    visible:        true
                }

                Rectangle {
                    anchors.centerIn:   parent
                    width:              size * 0.001
                    height:             size * 0.001
                    opacity:            1

                    QGCLabel {
                        text:               "Starter"
                        anchors.bottomMargin:       1
                        font.family:        vehicle ? ScreenTools.demiboldFontFamily : ScreenTools.normalFontFamily
                        font.pointSize:     12
                        color:              "red"
                        anchors.centerIn:   parent
                       }
                    QGCLabel {
                        text:               qsTr("\n")+"Throttle"
                        font.family:        vehicle ? ScreenTools.demiboldFontFamily : ScreenTools.normalFontFamily
                        font.pointSize:     12
                        color:              "blue"
                        anchors.centerIn:   parent
                       }
                }
            }

        Rectangle {
            id:             smask
            anchors.fill:   sinstrument
            radius:         width / 2
            color:          "black"
            visible:        false
        }

        OpacityMask {
            anchors.fill: sinstrument
            source: sinstrument
            maskSource: smask
        }

        Rectangle {
            id:             sborderRect
            anchors.fill:   parent
            radius:         width / 2
            color:          Qt.rgba(0,0,0,0)
            border.width:   1
        }
    }

   /* Item {
        id:                 _dataItem
        anchors.topMargin:  ScreenTools.defaultFontPixelHeight / 4
        anchors.top:        parent.bottom
        width:  parent.width
        height: parent.width/2*/


    Rectangle {
        id:             spacer1
        height: parent.width/2+1
        color:          Qt.rgba(0,0,0,0)
        border.width:   1
    }

        QGCButton {
            id:                     startStopButton
            //anchors.horizontalCenter: parent.horizontalCenter
            anchors.top:        spacer1.bottom
            anchors.topMargin:  10
            text:                   qsTr("Start/stop")
            primary:                true
            onClicked:              _activeVehicle.doEngineControl()
        }


        QGCLabel {
            id:                 rpmlabel
            anchors.top:        startStopButton.bottom
            anchors.topMargin:  ScreenTools.defaultFontPixelHeight / 8
            width:                  parent.width
            horizontalAlignment:    Text.AlignHCenter
            text:                   _activeVehicle ?  qsTr("RPM: ") + _activeVehicle.ice.rpm.enumOrValueString : qsTr("RPM: 0")
            visible:                true
            font.pointSize:         _labelFontSize
            font.family:            ScreenTools.demiboldFontFamily
        }
        QGCLabel {
            id:                 icetlabel
            anchors.top:        rpmlabel.bottom
            anchors.topMargin:  ScreenTools.defaultFontPixelHeight / 8
            width:                  parent.width
            horizontalAlignment:    Text.AlignHCenter
            text:                   _activeVehicle ? "ICE Temp: " + _activeVehicle.ice.iceTemp.enumOrValueString : "ICE Temp: 0"
            visible:                true
            font.pointSize:         _labelFontSize
            font.family:            ScreenTools.demiboldFontFamily
        }
        QGCLabel {
            id:                 gentlabel
            anchors.top:        icetlabel.bottom
            anchors.topMargin:  ScreenTools.defaultFontPixelHeight / 8
            width:                  parent.width
            horizontalAlignment:    Text.AlignHCenter
            text:                   _activeVehicle ? "Gen Temp: " + _activeVehicle.ice.genTemp.enumOrValueString : "Gen Temp: 0"
            visible:                true
            font.pointSize:         _labelFontSize
            font.family:            ScreenTools.demiboldFontFamily
        }
        QGCLabel {
            id:                 chargelabel
            anchors.top:        gentlabel.bottom
            anchors.topMargin:  ScreenTools.defaultFontPixelHeight / 8
            width:                  parent.width
            horizontalAlignment:    Text.AlignHCenter
            text:                   _activeVehicle ? "Charge: " + _activeVehicle.ice.chargeCurrent.enumOrValueString : "Charge: 0"
            visible:                true
            font.pointSize:         _labelFontSize
            font.family:            ScreenTools.demiboldFontFamily
        }
   // }
}
