//
//  ValueTypes.swift
//  Control Room
//
//  Created by Aaron Vizzini on 15/07/2017.
//  Copyright © 2017 Aaron Vizzini. All rights reserved.
//

import Foundation

/// An enaum for the possible Lightroom Development Values that could be modified by this app.
enum ValueType: String {
    case starRating = "starRating"
    case bwColor = "bwColor"
    
    //Adjust-Basic Panel
    case Temperature = "Temperature"
    case Tint = "Tint"
    case Exposure = "Exposure"
    case Contrast = "Contrast"
    case Highlights = "Highlights"
    case Shadows = "Shadows"
    case Whites = "Whites"
    case Blacks = "Blacks"
    case Clarity = "Clarity"
    case Vibrance = "Vibrance"
    case Saturation = "Saturation"
    case Brightness = "Brightness"
    
    //Tone Panel
    case ParametricDarks = "ParametricDarks"
    case ParametricLights = "ParametricLights"
    case ParametricShadows = "ParametricShadows"
    case ParametricHighlights = "ParametricHighlights"
    case ParametricShadowSplit = "ParametricShadowSplit"
    case ParametricMidtoneSplit = "ParametricMidtoneSplit"
    case ParametricHighlightSplit = "ParametricHighlightSplit"
    
    //Mixer Panel
    //HSL / Color
    case SaturationAdjustmentRed = "SaturationAdjustmentRed"
    case SaturationAdjustmentOrange = "SaturationAdjustmentOrange"
    case SaturationAdjustmentYellow = "SaturationAdjustmentYellow"
    case SaturationAdjustmentGreen = "SaturationAdjustmentGreen"
    case SaturationAdjustmentAqua = "SaturationAdjustmentAqua"
    case SaturationAdjustmentBlue = "SaturationAdjustmentBlue"
    case SaturationAdjustmentPurple = "SaturationAdjustmentPurple"
    case SaturationAdjustmentMagenta = "SaturationAdjustmentMagenta"
    case HueAdjustmentRed = "HueAdjustmentRed"
    case HueAdjustmentOrange = "HueAdjustmentOrange"
    case HueAdjustmentYellow = "HueAdjustmentYellow"
    case HueAdjustmentGreen = "HueAdjustmentGreen"
    case HueAdjustmentAqua = "HueAdjustmentAqua"
    case HueAdjustmentBlue = "HueAdjustmentBlue"
    case HueAdjustmentPurple = "HueAdjustmentPurple"
    case HueAdjustmentMagenta = "HueAdjustmentMagenta"
    case LuminanceAdjustmentRed = "LuminanceAdjustmentRed"
    case LuminanceAdjustmentOrange = "LuminanceAdjustmentOrange"
    case LuminanceAdjustmentYellow = "LuminanceAdjustmentYellow"
    case LuminanceAdjustmentGreen = "LuminanceAdjustmentGreen"
    case LuminanceAdjustmentAqua = "LuminanceAdjustmentAqua"
    case LuminanceAdjustmentBlue = "LuminanceAdjustmentBlue"
    case LuminanceAdjustmentPurple = "LuminanceAdjustmentPurple"
    case LuminanceAdjustmentMagenta = "LuminanceAdjustmentMagenta"
    
    // B & W
    case GrayMixerRed = "GrayMixerRed"
    case GrayMixerOrange = "GrayMixerOrange"
    case GrayMixerYellow = "GrayMixerYellow"
    case GrayMixerGreen = "GrayMixerGreen"
    case GrayMixerAqua = "GrayMixerAqua"
    case GrayMixerBlue = "TempGrayMixerBlueerature"
    case GrayMixerPurple = "GrayMixerPurple"
    case GrayMixerMagenta = "GrayMixerMagenta"
    
    // Split Toning
    case SplitToningShadowHue = "SplitToningShadowHue"
    case SplitToningShadowSaturation = "SplitToningShadowSaturation"
    case SplitToningHighlightHue = "SplitToningHighlightHue"
    case SplitToningHighlightSaturation = "SplitToningHighlightSaturation"
    case SplitToningBalance = "SplitToningBalance"
    
    // Detail Panel
    case Sharpness = "Sharpness"
    case SharpenRadius = "SharpenRadius"
    case SharpenDetail = "SharpenDetail"
    case SharpenEdgeMasking = "SharpenEdgeMasking"
    case LuminanceSmoothing = "LuminanceSmoothing"
    case LuminanceNoiseReductionDetail = "LuminanceNoiseReductionDetail"
    case LuminanceNoiseReductionContrast = "LuminanceNoiseReductionContrast"
    case ColorNoiseReduction = "ColorNoiseReduction"
    case ColorNoiseReductionDetail = "ColorNoiseReductionDetail"
    case ColorNoiseReductionSmoothness = "ColorNoiseReductionSmoothness"
    
    //Effects Panel
    //-- Dehaze
    case Dehaze = "Dehaze"
    //-- Post-Crop Vignetting
    case PostCropVignetteAmount = "PostCropVignetteAmount"
    case PostCropVignetteMidpoint = "PostCropVignetteMidpoint"
    case PostCropVignetteFeather = "PostCropVignetteFeather"
    case PostCropVignetteRoundness = "PostCropVignetteRoundness"
    case PostCropVignetteStyle = "PostCropVignetteStyle"
    case PostCropVignetteHighlightContrast = "PostCropVignetteHighlightContrast"
    //-- Grain
    case GrainAmount = "GrainAmount"
    case GrainSize = "GrainSize"
    case GrainFrequency = "GrainFrequency"
    
    // Lens Correction Panel
    //-- Profile
    case LensProfileDistortionScale = "LensProfileDistortionScale"
    case LensProfileChromaticAberrationScale = "LensProfileChromaticAberrationScale"
    case LensProfileVignettingScale = "LensProfileVignettingScale"
    case LensManualDistortionAmount = "LensManualDistortionAmount"
    //-- Color
    case DefringePurpleAmount = "DefringePurpleAmount"
    case DefringePurpleHueLo = "DefringePurpleHueLo"
    case DefringePurpleHueHi = "DefringePurpleHueHi"
    case DefringeGreenAmount = "DefringeGreenAmount"
    case DefringeGreenHueLo = "DefringeGreenHueLo"
    case DefringeGreenHueHi = "DefringeGreenHueHi"
    //-- Manual Perspective
    case PerspectiveVertical = "PerspectiveVertical"
    case PerspectiveHorizontal = "PerspectiveHorizontal"
    case PerspectiveRotate = "PerspectiveRotate"
    case PerspectiveScale = "PerspectiveScale"
    case PerspectiveAspect = "PerspectiveAspect"
    case PerspectiveUpright = "PerspectiveUpright"
    
    // Calibrate Panel
    case ShadowTint = "ShadowTint"
    case RedHue = "RedHue"
    case RedSaturation = "RedSaturation"
    case GreenHue = "GreenHue"
    case GreenSaturation = "GreenSaturation"
    case BlueHue = "BlueHue"
    case BlueSaturation = "BlueSaturation"
    
    // Crop Angel
    case straightenAngl = "straightenAngl"
}
