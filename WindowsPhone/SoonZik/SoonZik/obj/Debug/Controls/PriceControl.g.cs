﻿

#pragma checksum "C:\Users\Gery\Documents\GitHub\Soonzik\WindowsPhone\SoonZik\SoonZik\Controls\PriceControl.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "67B49B67A080C18CB284C62943B333DB"
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace SoonZik.Controls
{
    partial class PriceControl : global::Windows.UI.Xaml.Controls.UserControl, global::Windows.UI.Xaml.Markup.IComponentConnector
    {
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
 
        public void Connect(int connectionId, object target)
        {
            switch(connectionId)
            {
            case 1:
                #line 23 "..\..\Controls\PriceControl.xaml"
                ((global::Windows.UI.Xaml.UIElement)(target)).GotFocus += this.ArtistSlider_OnGotFocus;
                 #line default
                 #line hidden
                break;
            case 2:
                #line 32 "..\..\Controls\PriceControl.xaml"
                ((global::Windows.UI.Xaml.Controls.Primitives.ButtonBase)(target)).Click += this.ButtonBase_OnClick;
                 #line default
                 #line hidden
                break;
            }
            this._contentLoaded = true;
        }
    }
}


