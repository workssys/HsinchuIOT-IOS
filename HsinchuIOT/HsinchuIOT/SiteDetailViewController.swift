//
//  SiteDetailViewController.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 1/1/16.
//  Copyright © 2016 SL Studio. All rights reserved.
//

import Foundation
import SwiftCharts


class SiteDetailViewController: BaseViewController{
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var btnRefresh: UIButton!
    
    @IBOutlet weak var btnTimeScope: UIButton!
    
    @IBOutlet weak var btnTimeScope2: UIButton!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var segChartInterval: UISegmentedControl!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var siteView: UIView!
 
    @IBOutlet weak var chartView: ChartBaseView!
    
    @IBOutlet weak var co2Legend: LegendView!
    
    @IBOutlet weak var temperatureLegend: LegendView!
   
    @IBOutlet weak var humidityLegend: LegendView!
    
    
    private var timer: NSTimer?
    
    var chart: Chart?
    
    var currentSite: Site!
    var currentChartType: ChartType!
    var rtChartDuration: Int?
    var aggrChartGranularity: AggregationChartGranularity?
    var chartStartTime: NSDate?
    var chartEndTime: NSDate?
    var chartData: [IOTSampleData] = []
    
    var rtChartRefreshTime: NSTimeInterval = 10
    
    var refreshIntervalQueue = dispatch_queue_create("refresh_interval_queue", DISPATCH_QUEUE_CONCURRENT)
    
    var stopRefresh = false
    
    enum ChartType{
        case Realtime, Aggregation
    }
    
    enum AggregationChartGranularity{
        case Seconds, Quarter, Hour, Hours, Day, Week, Month
    }
    
    var selectedView: ChartPointPopupView?
    var popups: [UIView] = []
    
    override func viewDidLoad() {
        lbTitle.text = currentSite.siteName
        segChartInterval.tintColor = Colors.TEXT_BLUE
        segChartInterval.setTitle(getString(StringKey.SITEDETAIL_TIMEINTERVAL_CURRENT), forSegmentAtIndex: 0)
        segChartInterval.setTitle(getString(StringKey.SITEDETAIL_TIMEINTERVAL_BY_15SECONDS), forSegmentAtIndex: 1)
        segChartInterval.setTitle(getString(StringKey.SITEDETAIL_TIMEINTERVAL_BY_QUARTER), forSegmentAtIndex: 2)
        segChartInterval.setTitle(getString(StringKey.SITEDETAIL_TIMEINTERVAL_BY_HOUR), forSegmentAtIndex: 3)
        segChartInterval.setTitle(getString(StringKey.SITEDETAIL_TIMEINTERVAL_BY_8HOURS), forSegmentAtIndex: 4)
        segChartInterval.setTitle(getString(StringKey.SITEDETAIL_TIMEINTERVAL_BY_DAY), forSegmentAtIndex: 5)
        segChartInterval.setTitle(getString(StringKey.SITEDETAIL_TIMEINTERVAL_BY_WEEK), forSegmentAtIndex: 6)
        segChartInterval.setTitle(getString(StringKey.SITEDETAIL_TIMEINTERVAL_BY_MONTH), forSegmentAtIndex: 7)
        
        co2Legend.color = Colors.CHART_CO2
        co2Legend.lineWidth = 2.0
        co2Legend.title = getString(StringKey.CHART_LEGEND_CO2)
        co2Legend.font = Fonts.FONT_CHART_LEGEND
        
        temperatureLegend.color = Colors.CHART_TEMPERATURE
        temperatureLegend.lineWidth = 2.0
        temperatureLegend.title = getString(StringKey.CHART_LEGEND_TEMPERATURE)
        temperatureLegend.font = Fonts.FONT_CHART_LEGEND
        
        humidityLegend.color = Colors.CHART_HUMIDITY
        humidityLegend.lineWidth = 2.0
        humidityLegend.title = getString(StringKey.CHART_LEGEND_HUMIDITY)
        humidityLegend.font = Fonts.FONT_CHART_LEGEND
        
        stopRefresh = false
        //createChart()
        
        getChartData()
        
    }

    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        stopRefresh = true
    }
    
    @IBAction func btnBackClicked(sender: UIButton) {
        IOTServer.getServer().cancelAllRequests()
        
        self.dismissViewControllerAnimated(true) {
            
        }
    }
    
    @IBAction func btnRefreshClicked(sender: UIButton) {
    }
    
    @IBAction func btnTimeScopeClicked(sender: UIButton) {
    }
    
    @IBAction func btnTimeScope2Clicked(sender: UIButton) {
    }

    func getChartData(){
    
        sendQueryChartDataRequest()
        //timer = NSTimer.scheduledTimerWithTimeInterval(25.0, target: self, selector: "sendQueryChartDataRequest:", userInfo: nil, repeats:false);
        //timer!.fire()
        
    }
    
    func sendQueryChartDataRequest(){
        if let sessionID = SessionManager.sharedInstance.session?.sessionID {
            if let deviceID = currentSite.device?.deviceID {
                
                if currentChartType == ChartType.Realtime{
                    showWaitingBar()
                    
                    var duration = 10
                    if let d = rtChartDuration{
                        duration = d
                    }
                    
                    IOTServer.getServer().getDeviceRealtimeDataList(sessionID,
                        deviceID: deviceID,
                        recordNumber: 12 * duration,
                        onSucceed: updateChart,
                        onFailed: showError)
                    
                }else if currentChartType == ChartType.Aggregation{
                    var to = NSDate()
                    var from = to.dateByAddingTimeInterval(-10 * 60)
                    if let f = chartStartTime{
                        from = f
                    }
                    if let t = chartEndTime{
                        to = t
                    }
                    var granularity = AggregationChartGranularity.Seconds
                    if let g = aggrChartGranularity{
                        granularity = g
                    }
                    
                    switch granularity {
                    case AggregationChartGranularity.Seconds:
                        showWaitingBar()
                        IOTServer.getServer().getDeviceAggregationDataListBy15Seconds(sessionID, deviceID: deviceID, from: from, to: to, onSucceed: updateChart, onFailed: showError)
                    case AggregationChartGranularity.Quarter:
                        showWaitingBar()
                        IOTServer.getServer().getDeviceAggregationDataListBy1Quarter(sessionID, deviceID: deviceID, from: from, to: to, onSucceed: updateChart, onFailed: showError)
                    case AggregationChartGranularity.Hour:
                        showWaitingBar()
                        IOTServer.getServer().getDeviceAggregationDataListBy1Hour(sessionID, deviceID: deviceID, from: from, to: to, onSucceed: updateChart, onFailed: showError)
                    case AggregationChartGranularity.Hours:
                        showWaitingBar()
                        IOTServer.getServer().getDeviceAggregationDataListBy8Hours(sessionID, deviceID: deviceID, from: from, to: to, onSucceed: updateChart, onFailed: showError)
                    case AggregationChartGranularity.Day:
                        showWaitingBar()
                        IOTServer.getServer().getDeviceAggregationDataListBy1Day(sessionID, deviceID: deviceID, from: from, to: to, onSucceed: updateChart, onFailed: showError)
                    case AggregationChartGranularity.Week:
                        showWaitingBar()
                        IOTServer.getServer().getDeviceAggregationDataListBy1Week(sessionID, deviceID: deviceID, from: from, to: to, onSucceed: updateChart, onFailed: showError)
                    case AggregationChartGranularity.Month:
                        showWaitingBar()
                        IOTServer.getServer().getDeviceAggregationDataListBy1Month(sessionID, deviceID: deviceID, from: from, to: to, onSucceed: updateChart, onFailed: showError)
                        
                    }
                }
            }else{
                showError(IOTError(errorCode: IOTError.InvalidDeviceError, errorGroup: "sendQueryChartDataRequest"))
            }
        }else{
            showError(IOTError(errorCode: IOTError.InvalidSessionError, errorGroup: "sendQueryChartDataRequest"))
        }
    }
    
    
    func updateChart(data: [IOTSampleData]){
        if stopRefresh {
            return
        }
        
        hideWaitingBar()
        
        chartData = data
        
        createChartView()
        
        if currentChartType == ChartType.Realtime && (!stopRefresh){
            dispatch_async(refreshIntervalQueue){
                NSThread.sleepForTimeInterval(self.rtChartRefreshTime)
                dispatch_async(dispatch_get_main_queue()){
                    if(!self.stopRefresh) {
                        self.sendQueryChartDataRequest()
                    }
                }
            }
        }
    
    }
    
    func createChartView(){
        
        
        let timeFormatter = getChartTimeFormatter()
        
        let chartPointsCO2 = createChartPoints(IOTSampleData.SampleType.CO2, formatter: timeFormatter, color: Colors.CHART_CO2)
        let chartPointsTemp = createChartPoints(IOTSampleData.SampleType.Temperature, formatter: timeFormatter, color: Colors.CHART_TEMPERATURE)
        let chartPointsHum = createChartPoints(IOTSampleData.SampleType.Humidity, formatter: timeFormatter, color: Colors.CHART_HUMIDITY)
        
        let chartSettings = getChartSettings()
        
        let chartViewFrame = getChartViewFrame()
        
        let xAxisValue = ChartAxisValuesGenerator.generateXAxisValuesWithChartPoints(chartPointsCO2,
            minSegmentCount: 4,
            maxSegmentCount: 6,
            axisValueGenerator: { (chartPointValue) -> ChartAxisValue in
                return ChartAxisValueDate(date: NSDate(timeIntervalSince1970: chartPointValue),
                    formatter: timeFormatter,
                    labelSettings: ChartLabelSettings(font: Fonts.FONT_CHART_AXIS, fontColor: Colors.CHART_AXIS))
            },
            addPaddingSegmentIfEdge: false)
        
        
        let yValuesCO2 = ChartAxisValuesGenerator.generateYAxisValuesWithChartPoints(chartPointsCO2,
            minSegmentCount: 10,
            maxSegmentCount: 20,
            multiple: 2,
            axisValueGenerator: { (chartPointValue) -> ChartAxisValue in
                return ChartAxisValueDouble(chartPointValue,
                    labelSettings: ChartLabelSettings(font: Fonts.FONT_CHART_AXIS, fontColor: Colors.CHART_CO2))
            },
            addPaddingSegmentIfEdge: false)
        
        let yValuesTemp = ChartAxisValuesGenerator.generateYAxisValuesWithChartPoints(chartPointsTemp,
            minSegmentCount: 10,
            maxSegmentCount: 20,
            multiple: 2,
            axisValueGenerator: { (chartPointValue) -> ChartAxisValue in
                return ChartAxisValueDouble(chartPointValue,
                    labelSettings: ChartLabelSettings(font: Fonts.FONT_CHART_AXIS, fontColor: Colors.CHART_TEMPERATURE))
            },
            addPaddingSegmentIfEdge: false)
        
        let yValuesHum = ChartAxisValuesGenerator.generateYAxisValuesWithChartPoints(chartPointsHum,
            minSegmentCount: 10,
            maxSegmentCount: 20,
            multiple: 2,
            axisValueGenerator: { (chartPointValue) -> ChartAxisValue in
                return ChartAxisValueDouble(chartPointValue,
                    labelSettings: ChartLabelSettings(font: Fonts.FONT_CHART_AXIS, fontColor: Colors.CHART_HUMIDITY))
            },
            addPaddingSegmentIfEdge: false)
       
        let yLowModels: [ChartAxisModel] = [
            ChartAxisModel(axisValues: yValuesCO2,
                lineColor: Colors.CHART_AXIS,
                axisTitleLabels: [ChartAxisLabel(text: getString(StringKey.CHART_LEGEND_CO2),
                    settings: ChartLabelSettings(fontColor: Colors.CHART_CO2, font: Fonts.FONT_CHART_AXIS_TITLE).defaultVertical())])
        ]
        
        let yHighModels: [ChartAxisModel] = [
            ChartAxisModel(axisValues: yValuesTemp,
                lineColor: Colors.CHART_AXIS,
                axisTitleLabels: [ChartAxisLabel(text: getString(StringKey.CHART_LEGEND_TEMPERATURE),
                    settings: ChartLabelSettings(fontColor: Colors.CHART_TEMPERATURE, font: Fonts.FONT_CHART_AXIS_TITLE).defaultVertical())]),
            ChartAxisModel(axisValues: yValuesHum,
                lineColor: Colors.CHART_AXIS,
                axisTitleLabels: [ChartAxisLabel(text: getString(StringKey.CHART_LEGEND_HUMIDITY),
                    settings: ChartLabelSettings(fontColor: Colors.CHART_HUMIDITY, font: Fonts.FONT_CHART_AXIS_TITLE).defaultVertical())])
        ]
        
        let xLowModels: [ChartAxisModel] = [
            ChartAxisModel(axisValues: xAxisValue,
                lineColor: Colors.CHART_AXIS,
                axisTitleLabels: [ChartAxisLabel(text: "",
                    settings: ChartLabelSettings(fontColor: Colors.CHART_AXIS, font: Fonts.FONT_CHART_AXIS_TITLE))])
        ]
        
        
        let popupViewGeneratorCO2 = createPopupViewGenerator(Colors.CHART_CO2, selectedColor: UIColor.blackColor())
        let popupViewGeneratorTemp = createPopupViewGenerator(Colors.CHART_TEMPERATURE, selectedColor: UIColor.blackColor())
        let popupViewGeneratorHum = createPopupViewGenerator(Colors.CHART_HUMIDITY, selectedColor: UIColor.blackColor())
        
        
        
        // calculate coords space in the background to keep UI smooth
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let coordsSpace = ChartCoordsSpace(chartSettings: chartSettings,
                chartSize: chartViewFrame.size,
                yLowModels: yLowModels,
                yHighModels: yHighModels,
                xLowModels: xLowModels,
                xHighModels: [])
            
            dispatch_async(dispatch_get_main_queue()) {
                
                let chartInnerFrame = coordsSpace.chartInnerFrame
                
                // create axes
                let yLowAxes = coordsSpace.yLowAxes
                let yHighAxes = coordsSpace.yHighAxes
                let xLowAxes = coordsSpace.xLowAxes
                //let xHighAxes = coordsSpace.xHighAxes
                
                // create layers with references to axes
                let lineModelCO2 = ChartLineModel(chartPoints: chartPointsCO2, lineColor: Colors.CHART_CO2, animDuration: 1, animDelay: 0)
                let lineModelTemp = ChartLineModel(chartPoints: chartPointsTemp, lineColor: Colors.CHART_TEMPERATURE, animDuration: 1, animDelay: 0)
                let lineModelHum = ChartLineModel(chartPoints: chartPointsHum, lineColor: Colors.CHART_HUMIDITY, animDuration: 1, animDelay: 0)
                
                let chartPointsLineLayerCO2 = ChartPointsLineLayer<ChartPoint>(xAxis: xLowAxes[0],
                    yAxis: yLowAxes[0],
                    innerFrame: chartInnerFrame,
                    lineModels: [lineModelCO2])
                
                let chartPointsLineLayerTemp = ChartPointsLineLayer<ChartPoint>(xAxis: xLowAxes[0],
                    yAxis: yHighAxes[0],
                    innerFrame: chartInnerFrame,
                    lineModels: [lineModelTemp])
                
                let chartPointsLineLayerHum = ChartPointsLineLayer<ChartPoint>(xAxis: xLowAxes[0],
                    yAxis: yHighAxes[1],
                    innerFrame: chartInnerFrame,
                    lineModels: [lineModelHum])
            
                
                let lineLayers = [chartPointsLineLayerCO2, chartPointsLineLayerTemp, chartPointsLineLayerHum]
                
                
                let itemsDelay: Float = 0.0
               
                
                let chartPointsCircleLayerCO2 = ChartPointsViewsLayer(xAxis: xLowAxes[0],
                    yAxis: yLowAxes[0],
                    innerFrame: chartInnerFrame,
                    chartPoints: chartPointsCO2,
                    viewGenerator: popupViewGeneratorCO2,
                    displayDelay: 0,
                    delayBetweenItems: itemsDelay)
                
                let chartPointsCircleLayerTemp = ChartPointsViewsLayer(xAxis: xLowAxes[0],
                    yAxis: yHighAxes[0],
                    innerFrame: chartInnerFrame,
                    chartPoints: chartPointsTemp,
                    viewGenerator: popupViewGeneratorTemp,
                    displayDelay: 0,
                    delayBetweenItems: itemsDelay)
                
                let chartPointsCircleLayerHum = ChartPointsViewsLayer(xAxis: xLowAxes[0],
                    yAxis: yHighAxes[1],
                    innerFrame: chartInnerFrame,
                    chartPoints: chartPointsHum,
                    viewGenerator: popupViewGeneratorHum,
                    displayDelay: 0,
                    delayBetweenItems: itemsDelay)
                
                
                let layers: [ChartLayer] = [
                    yLowAxes[0],
                    yHighAxes[0],
                    yHighAxes[1],
                    xLowAxes[0],
                    lineLayers[0],
                    lineLayers[1],
                    lineLayers[2],
                    chartPointsCircleLayerCO2,
                    chartPointsCircleLayerTemp,
                    chartPointsCircleLayerHum,

                    
                ]
                
                let newChart = Chart(
                    //view: self.chartView,
                    frame: chartViewFrame,
                    layers: layers
                )
                
                if let c = self.chart{
                    c.view.removeFromSuperview()
                }

                //newChart.view.backgroundColor = UIColor.redColor()
                self.siteView.addSubview(newChart.view)
                
                self.chart = newChart
            }
        }

    }
    typealias PopupViewGenerator = ((chartPointModel: ChartPointLayerModel<ChartPoint>, layer: ChartPointsViewsLayer<ChartPoint, UIView>, chart: Chart) -> UIView?)
    
    private func createPopupViewGenerator(pointColor: UIColor, selectedColor: UIColor) -> PopupViewGenerator {
        
        let popupViewGenerator = {(chartPointModel: ChartPointLayerModel, layer: ChartPointsLayer, chart: Chart) -> UIView? in
            
            let (chartPoint, screenLoc) = (chartPointModel.chartPoint, chartPointModel.screenLoc)
            
            let v = ChartPointPopupView(chartPoint: chartPoint, center: screenLoc, diameter: 5, pointColor: pointColor, selectedPointColor: selectedColor, hideText: false, textFont: Fonts.FONT_CHART_POINT_TEXT, textVerticalPadding: 2, textColor: pointColor, selectedTextColor: selectedColor)
            
            v.viewTapped = {view in
                for p in self.popups {p.removeFromSuperview()}
                self.selectedView?.selected = false
                
                let w: CGFloat = 150
                let h: CGFloat = 80
                
                let x: CGFloat = {
                    let attempt = screenLoc.x - (w/2)
                    let leftBound: CGFloat = chart.bounds.origin.x
                    let rightBound = chart.bounds.size.width - 5
                    if attempt < leftBound {
                        return view.frame.origin.x
                    } else if attempt + w > rightBound {
                        return rightBound - w
                    }
                    return attempt
                }()
                
                let frame = CGRectMake(x, screenLoc.y - (h + 12), w, h)
                
                let bubbleView = InfoBubble(frame: frame, arrowWidth: 28, arrowHeight: 14, bgColor: UIColor.blackColor(), arrowX: screenLoc.x - x)
                chart.addSubview(bubbleView)
                
                bubbleView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0, 0), CGAffineTransformMakeTranslation(0, 100))
                let infoView = UILabel(frame: CGRectMake(0, 10, w, h - 30))
                infoView.textColor = UIColor.whiteColor()
                infoView.backgroundColor = UIColor.blackColor()
                infoView.text = "Time: \(chartPoint.x.text), Value:\(chartPoint.y.text)"
                infoView.font = Fonts.FONT_CHART_POINT_HINT
                infoView.textAlignment = NSTextAlignment.Center
                
                bubbleView.addSubview(infoView)
                self.popups.append(bubbleView)
                
                UIView.animateWithDuration(0.0, delay: 0, options: UIViewAnimationOptions(), animations: {
                    view.selected = true
                    self.selectedView = view
                    
                    bubbleView.transform = CGAffineTransformIdentity
                    }, completion: {finished in})
            }
            
            return v
        }
        
        return popupViewGenerator

    }
    
    private func getChartViewFrame() -> CGRect {
        return CGRectMake(0, 0, self.chartView.frame.size.width, self.chartView.frame.size.height)
    }
    
    private func getChartSettings() -> ChartSettings{
        
        let chartSettings = ChartSettings()
        
        chartSettings.leading = 50
        chartSettings.top = 20
        chartSettings.trailing = 50
        chartSettings.bottom = 0
        chartSettings.labelsToAxisSpacingX = 5
        chartSettings.labelsToAxisSpacingY = 5
        chartSettings.axisTitleLabelsToLabelsSpacing = 4
        chartSettings.axisStrokeWidth = 2
        chartSettings.spacingBetweenAxesX = 8
        chartSettings.spacingBetweenAxesY = 8
        
        return chartSettings
    }
    
    private func getChartTimeFormatter() -> NSDateFormatter {
        let result = NSDateFormatter()
        
        if currentChartType == ChartType.Aggregation {
            
            var granularity = AggregationChartGranularity.Seconds
            if let g = aggrChartGranularity{
                granularity = g
            }
            
            switch granularity {
            case AggregationChartGranularity.Seconds:
                result.dateFormat = "yyyy/MM/dd-HH:mm:ss"
            case AggregationChartGranularity.Quarter:
                result.dateFormat = "yyyy/MM/dd-HH:mm:ss"
            case AggregationChartGranularity.Hour:
                result.dateFormat = "yyyy/MM/dd-HH:mm:ss"
            case AggregationChartGranularity.Hours:
                result.dateFormat = "yyyy/MM/dd-HH:mm:ss"
            case AggregationChartGranularity.Day:
                result.dateFormat = "yyyy/MM/dd"
            case AggregationChartGranularity.Week:
                result.dateFormat = "yyyy/MM/dd"
            case AggregationChartGranularity.Month:
                result.dateFormat = "yyyy/MM"
            }
        }else{
            result.dateFormat = "HH:mm:ss"
        }
        
        return result
        
    }
    
    private func createChartPoints(type: IOTSampleData.SampleType, formatter: NSDateFormatter, color: UIColor) -> [ChartPoint] {
        var result: [ChartPoint] = []
        
        for data in chartData{
            print("\(data)")
            if data.type == type {
                result.append(createChartPoint(data.time!, Double(data.value!), formatter, color))
            }
        }
        return result
    }
    
    private func createChartPoint(x: NSDate, _ y: Double, _ formatter: NSDateFormatter, _ labelColor: UIColor) -> ChartPoint {
        let labelSettings = ChartLabelSettings(font: Fonts.FONT_CHART_AXIS, fontColor: labelColor)
        
        return ChartPoint(x: IOTChartAxisValueDate(date: x, formatter: formatter, labelSettings: labelSettings), y: ChartAxisValueDouble(y, labelSettings: labelSettings))
    }
    

}

