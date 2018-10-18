/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


import QtQuick 2.3

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FlightMap     1.0
import QGroundControl.Palette       1.0

Rectangle {
    id:             root
    width:          getPreferredInstrumentWidth()*1.5
    height:         _outerRadius * 2
    radius:         _outerRadius
    color:          qgcPal.window
    border.width:   1
    border.color:   _isSatellite ? qgcPal.mapWidgetBorderLight : qgcPal.mapWidgetBorderDark

    property var    _qgcView:           qgcView
    property real   _innerRadius:       (width - (_topBottomMargin * 3)) / 4
    property real   _outerRadius:       _innerRadius + _topBottomMargin
    property real   _defaultSize:       ScreenTools.defaultFontPixelHeight * (9)
    property real   _sizeRatio:         ScreenTools.isTinyScreen ? (width / _defaultSize) * 0.5 : width / _defaultSize
    property real   _bigFontSize:       ScreenTools.defaultFontPointSize * 2.5  * _sizeRatio
    property real   _normalFontSize:    ScreenTools.defaultFontPointSize * 1.5  * _sizeRatio
    property real   _labelFontSize:     ScreenTools.defaultFontPointSize * 0.75 * _sizeRatio
    property real   _spacing:           ScreenTools.defaultFontPixelHeight * 0.33
    property real   _topBottomMargin:   (width * 0.05) / 2
    property real   _availableValueHeight: maxHeight - (root.height + _valuesItem.anchors.topMargin)
    property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle

    // Prevent all clicks from going through to lower layers
    DeadMouseArea {
        anchors.fill: parent
    }

    QGCPalette { id: qgcPal }

    QGCAttitudeWidget {
        id:                 attitude
        anchors.leftMargin: _topBottomMargin
        anchors.left:       parent.left
        size:               _innerRadius * 2
        vehicle:            _activeVehicle
        anchors.verticalCenter: parent.verticalCenter
    }

    QGCCompassWidget {
        id:                 compass
        anchors.leftMargin: _spacing
        anchors.left:       attitude.right
        size:               _innerRadius * 2
        vehicle:            _activeVehicle
        anchors.verticalCenter: parent.verticalCenter
    }

    Item {
        id:                 _valuesItem
        anchors.topMargin:  ScreenTools.defaultFontPixelHeight / 4
        anchors.top:        parent.bottom
        width:              parent.width
        height:             _valuesWidget.height
        visible:            widgetRoot.showValues

        // Prevent all clicks from going through to lower layers
        DeadMouseArea {
            anchors.fill: parent
        }

        Rectangle {
            anchors.fill:   _valuesWidget
            color:          qgcPal.window
        }

        PageView {
            id:                 _valuesWidget
            anchors.margins:    1
            anchors.left:       parent.left
            anchors.right:      parent.right
            qgcView:            root._qgcView
            maxHeight:          _availableValueHeight
        }
    }

    Item {
        id:                 _ICEItem
        anchors.topMargin:  ScreenTools.defaultFontPixelHeight / 4
        anchors.top:        parent.bottom
        width:              parent.width
        height:             _valuesWidget.height
        visible:            widgetRoot.showValues

        Rectangle {
            id:                         _icews1
            anchors.topMargin:  ScreenTools.defaultFontPixelHeight / 4
            anchors.top:        parent.bottom
            anchors.horizontalCenter:   parent.horizontalCenter
            height:                     _outerRadius * 4
            width:                      parent.width
            color:                      qgcPal.window

            QGCICEWidget {
                id:                 icew
                anchors.topMargin:  ScreenTools.defaultFontPixelHeight / 4
                anchors.leftMargin: _topBottomMargin
                anchors.left:       parent.left
                anchors.top:        parent.top
                size:               _innerRadius * 2
                vehicle:            _activeVehicle
                //anchors.verticalCenter: parent.verticalCenter
            }

            QGCICEWidget {
                id:                 icew2
                anchors.topMargin:  ScreenTools.defaultFontPixelHeight / 4
                anchors.leftMargin: _topBottomMargin
                anchors.left:       icew.right
                anchors.top:        parent.top
                size:               _innerRadius * 2
                vehicle:            _activeVehicle
                temperature_widget: false
                //anchors.verticalCenter: parent.verticalCenter
            }

            QGCLabel {
                width:                  parent.width
                horizontalAlignment:    Text.AlignHCenter
                wrapMode:               Text.WordWrap
                text:                   _activeVehicle ? "RPM: " + _activeVehicle.ice.rpm.enumOrValueString : "RPM: 0"
                font.pointSize:         ScreenTools.mediumFontPointSize * 2
                font.family:            ScreenTools.demiboldFontFamily
                y: _innerRadius*2+10
            }
            QGCLabel {
                width:                  parent.width
                horizontalAlignment:    Text.AlignHCenter
                wrapMode:               Text.WordWrap
                text:                   _activeVehicle ? "ICE t.: " + _activeVehicle.ice.iceTemp.enumOrValueString : "ICE t.: 0"
                font.pointSize:         ScreenTools.mediumFontPointSize * 2
                font.family:            ScreenTools.demiboldFontFamily
                y: _innerRadius*2+40
            }
            QGCLabel {
                width:                  parent.width
                horizontalAlignment:    Text.AlignHCenter
                wrapMode:               Text.WordWrap
                text:                   _activeVehicle ? "Gen.: T " + _activeVehicle.ice.genTemp.enumOrValueString : "Gen. T: 0"
                font.pointSize:         ScreenTools.mediumFontPointSize * 2
                font.family:            ScreenTools.demiboldFontFamily
                y: _innerRadius*2+70
            }
            QGCLabel {
                width:                  parent.width
                horizontalAlignment:    Text.AlignHCenter
                wrapMode:               Text.WordWrap
                text:                   _activeVehicle ? "Curr.: " + _activeVehicle.ice.chargeCurrent.enumOrValueString : "Curr.: 0"
                font.pointSize:         ScreenTools.mediumFontPointSize * 2
                font.family:            ScreenTools.demiboldFontFamily
                y: _innerRadius*2+100
            }

            /*ProgressBar {
                id:             xBar
                height:         50
                orientation:    Qt.Vertical
                minimumValue:   0
                maximumValue:   200
                y: _innerRadius*2+100
                value:          150
            }*/

        }


    }
}
