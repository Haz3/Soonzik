﻿

#pragma checksum "C:\Users\Juan-Pablo Bastardos\Documents\GitHub\SoonZik\Soonzik\WindowsPhone\SoonZik\SoonZik\Controls\GlobalMenuControl.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "DB462CB7AD847714517F6D11E0A6B9ED"
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
    partial class GlobalMenuControl : global::Windows.UI.Xaml.Controls.UserControl, global::Windows.UI.Xaml.Markup.IComponentConnector
    {
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
 
        public void Connect(int connectionId, object target)
        {
            switch(connectionId)
            {
            case 1:
                #line 29 "..\..\Controls\GlobalMenuControl.xaml"
                ((global::Windows.UI.Xaml.Media.Animation.Timeline)(target)).Completed += this.MenuAloneClose_OnCompleted;
                 #line default
                 #line hidden
                break;
            case 2:
                #line 32 "..\..\Controls\GlobalMenuControl.xaml"
                ((global::Windows.UI.Xaml.Media.Animation.Timeline)(target)).Completed += this.SearchAloneBack_OnCompleted;
                 #line default
                 #line hidden
                break;
            case 3:
                #line 58 "..\..\Controls\GlobalMenuControl.xaml"
                ((global::Windows.UI.Xaml.UIElement)(target)).Tapped += this.AlbumStackPanel_OnTapped;
                 #line default
                 #line hidden
                break;
            case 4:
                #line 52 "..\..\Controls\GlobalMenuControl.xaml"
                ((global::Windows.UI.Xaml.UIElement)(target)).Tapped += this.MusicStackPanel_OnTapped;
                 #line default
                 #line hidden
                break;
            case 5:
                #line 46 "..\..\Controls\GlobalMenuControl.xaml"
                ((global::Windows.UI.Xaml.UIElement)(target)).Tapped += this.ArtistStackPanel_OnTapped;
                 #line default
                 #line hidden
                break;
            case 6:
                #line 40 "..\..\Controls\GlobalMenuControl.xaml"
                ((global::Windows.UI.Xaml.UIElement)(target)).Tapped += this.UsersStackPanel_OnTapped;
                 #line default
                 #line hidden
                break;
            case 7:
                #line 167 "..\..\Controls\GlobalMenuControl.xaml"
                ((global::Windows.UI.Xaml.UIElement)(target)).Tapped += this.GlobalGrid_OnTapped;
                 #line default
                 #line hidden
                break;
            case 8:
                #line 149 "..\..\Controls\GlobalMenuControl.xaml"
                ((global::Windows.UI.Xaml.Controls.TextBox)(target)).TextChanged += this.SearchTextBlock_OnTextChanged;
                 #line default
                 #line hidden
                break;
            }
            this._contentLoaded = true;
        }
    }
}


