﻿

#pragma checksum "C:\Users\Gery\Documents\GitHub\Soonzik\WindowsPhone\SoonZik\SoonZik\Views\MyMusic.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "EBE808BD60D65B1FB2DC3377F8866AE9"
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace SoonZik.Views
{
    partial class MyMusic : global::Windows.UI.Xaml.Controls.Page, global::Windows.UI.Xaml.Markup.IComponentConnector
    {
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
 
        public void Connect(int connectionId, object target)
        {
            switch(connectionId)
            {
            case 1:
                #line 48 "..\..\Views\MyMusic.xaml"
                ((global::Windows.UI.Xaml.UIElement)(target)).Tapped += this.UIElement_OnTapped;
                 #line default
                 #line hidden
                break;
            case 2:
                #line 66 "..\..\Views\MyMusic.xaml"
                ((global::Windows.UI.Xaml.UIElement)(target)).Tapped += this.PlayImage_OnTapped;
                 #line default
                 #line hidden
                break;
            case 3:
                #line 70 "..\..\Views\MyMusic.xaml"
                ((global::Windows.UI.Xaml.Controls.MenuFlyoutItem)(target)).Click += this.ItemPlaylist_OnTapped;
                 #line default
                 #line hidden
                break;
            case 4:
                #line 71 "..\..\Views\MyMusic.xaml"
                ((global::Windows.UI.Xaml.Controls.MenuFlyoutItem)(target)).Click += this.ItemCart_OnTapped;
                 #line default
                 #line hidden
                break;
            case 5:
                #line 72 "..\..\Views\MyMusic.xaml"
                ((global::Windows.UI.Xaml.Controls.MenuFlyoutItem)(target)).Click += this.ItemAlbum_OnTapped;
                 #line default
                 #line hidden
                break;
            case 6:
                #line 41 "..\..\Views\MyMusic.xaml"
                ((global::Windows.UI.Xaml.UIElement)(target)).Tapped += this.DeleteItem_OnTapped;
                 #line default
                 #line hidden
                break;
            }
            this._contentLoaded = true;
        }
    }
}


