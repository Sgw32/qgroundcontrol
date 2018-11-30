/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


import QtQuick 2.3
import QtQuick.Controls 1.2

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FlightMap     1.0
import QGroundControl.Palette       1.0

Rectangle {
    id:             root
    width:          getPreferredInstrumentWidth()*1.4
    height:         getPreferredInstrumentWidth()*1.5
    radius:         getPreferredInstrumentWidth()*0.3
    color:          qgcPal.window
    border.width:   1
    border.color:   _isSatellite ? qgcPal.mapWidgetBorderLight : qgcPal.mapWidgetBorderDark

    property var    _qgcView:           qgcView
    property real   _innerRadius:       (width - (_topBottomMargin * 3)) / 2
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

    /*property real _altitude:  _activeVehicle ? _activeVehicle.altitudeRelative.rawValue : 0
    property real _desiredAltitude:  _activeVehicle ? _activeVehicle.altitudeRelative.rawValue : 0
    property real _airSpeed:  _activeVehicle ? _activeVehicle.airSpeed.rawValue : 0
    property real _groundSpeed:  _activeVehicle ? _activeVehicle.groundSpeed.rawValue : 0
    property int _percent:  _activeVehicle ? _activeVehicle.battery.percentRemaining.rawValue : 0
    property real _voltage:  _activeVehicle ? _activeVehicle.battery.voltage.rawValue : 0
    property real _current:  _activeVehicle ? _activeVehicle.battery.current.rawValue : 0
*/

    property real _altitudeS:  _activeVehicle ? _activeVehicle.altitudeRelative.valueString : 0
    property real _altError:  _activeVehicle ? _activeVehicle.navCtl.altError.rawValue : 0
    property real _desiredAltitudeS:  _activeVehicle ? _activeVehicle.altitudeRelative.valueString : 0
    property real _airSpeedS:  _activeVehicle ? _activeVehicle.airSpeed.valueString : 0
    property real _groundSpeedS:  _activeVehicle ? _activeVehicle.groundSpeed.valueString : 0
    property int _percentS:  _activeVehicle ? _activeVehicle.battery.percentRemaining.valueString : 0
    property real _voltageS:  _activeVehicle ? _activeVehicle.battery.voltage.valueString : 0
    property real _currentS:  _activeVehicle ? _activeVehicle.battery.current.valueString : 0
    property real _altErrorConstrain1: _altError > 50 ? 50 : _altError
    property real _altErrorConstrain2: _altError < -50 ? -50 : _altError
    // Prevent all clicks from going through to lower layers
    DeadMouseArea {
        anchors.fill: parent
    }

    QGCPalette { id: qgcPal }

    QGCAttitudeWidget {
        id:                 attitude
        anchors.top:        root.top
        anchors.bottom:        root.bottom
        anchors.topMargin:  _topBottomMargin
        anchors.bottomMargin:  _topBottomMargin
        //anchors.leftMargin: _topBottomMargin
        //anchors.left:       parent.left
        size:               _innerRadius * 2
        vehicle:            _activeVehicle
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter:   parent.horizontalCenter
    }

    /*ProgressBar {
        id:             progressBar
        anchors.right:  attitude.right
        anchors.rightMargin:  ScreenTools.defaultFontPixelHeight / 4
        height:            150
        anchors.verticalCenter: attitude.verticalCenter
        orientation:    Qt.Vertical
        minimumValue:   0
        maximumValue:   100
        value:          _altError+50.0
    }*/

    Rectangle {
        id:             progressBar1
        anchors.right:  attitude.right
        anchors.rightMargin:  ScreenTools.defaultFontPixelHeight / 4
        height:            _altErrorConstrain1
        width: 5
        anchors.bottom: attitude.verticalCenter
        color:          Qt.rgba(1,0,0,0.7)
    }

    Rectangle {
        id:             progressBar2
        anchors.right:  attitude.right
        anchors.rightMargin:  ScreenTools.defaultFontPixelHeight / 4
        height:            -_altErrorConstrain2
        width: 5
        anchors.top: attitude.verticalCenter
        color:          Qt.rgba(1,0,0,0.7)
    }

    QGCLabel {
        id:                 altitude_att
        anchors.left:        attitude.right
        anchors.leftMargin:  -30
        anchors.verticalCenter: attitude.verticalCenter
        wrapMode:               Text.WordWrap
        text:                   _altitudeS + "\n" +_altError
        font.pointSize:         _labelFontSize/1.5
        font.family:            ScreenTools.demiboldFontFamily
    }

    QGCLabel {
        id:                 aspd_att
        anchors.left:        attitude.left
        anchors.leftMargin:  ScreenTools.defaultFontPixelHeight / 4
        anchors.verticalCenter: attitude.verticalCenter
        wrapMode:               Text.WordWrap
        text:                   _airSpeedS //"T2"
        font.pointSize:         _labelFontSize/1.5
        font.family:            ScreenTools.demiboldFontFamily
    }

    QGCLabel {
        id:                 asgs_att
        anchors.bottom:        attitude.bottom
        anchors.topMargin:  ScreenTools.defaultFontPixelHeight / 4
        anchors.rightMargin: 40
        anchors.right: attitude.horizontalCenter
        //wrapMode:               Text.WordWrap
        text:                   "AS" + _airSpeedS + "\nGS" +_groundSpeedS
        font.pointSize:         _labelFontSize/1.5
        font.family:            ScreenTools.demiboldFontFamily
    }

    QGCLabel {
        id:                 batt_att
        anchors.bottom:        attitude.bottom
        anchors.topMargin:  ScreenTools.defaultFontPixelHeight / 4
        anchors.leftMargin:  40
        anchors.left: attitude.horizontalCenter
        //wrapMode:               Text.WordWrap
        text:                   _voltageS
        font.pointSize:         _labelFontSize/1.5
        font.family:            ScreenTools.demiboldFontFamily
    }

    /*QGCCompassWidget {
        id:                 compass
        anchors.leftMargin: _spacing
        anchors.topMargin:  ScreenTools.defaultFontPixelHeight / 2
        anchors.top:       attitude.bottom
        size:               _innerRadius / 1.3
        vehicle:            _activeVehicle
        anchors.horizontalCenter:   parent.horizontalCenter
    }*/

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


}
