﻿

#pragma checksum "C:\Users\Juan-Pablo Bastardos\Documents\GitHub\SoonZik\Soonzik\WindowsPhone\SoonZik\SoonZik\Controls\PlayerControl.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "C743F3BE5D59A56632569B2A67F292BE"
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
    partial class PlayerControl : global::Windows.UI.Xaml.Controls.Page
    {
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.Grid GlobalPlayerGrid; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.MediaElement MyMediaElement; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.Grid CoverArtist; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.Grid TitlePanel; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.Grid SliderPanel; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.Grid ButtonPanel; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.Primitives.ToggleButton PlayButtonToggle; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.Primitives.ToggleButton ShuffleButtonToggle; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.Primitives.ToggleButton RepeatButtonToggle; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.Image RewindImage; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.Image ForwardImage; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.Slider TimeSlider; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private bool _contentLoaded;

        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        public void InitializeComponent()
        {
            if (_contentLoaded)
                return;

            _contentLoaded = true;
            global::Windows.UI.Xaml.Application.LoadComponent(this, new global::System.Uri("ms-appx:///Controls/PlayerControl.xaml"), global::Windows.UI.Xaml.Controls.Primitives.ComponentResourceLocation.Application);
 
            GlobalPlayerGrid = (global::Windows.UI.Xaml.Controls.Grid)this.FindName("GlobalPlayerGrid");
            MyMediaElement = (global::Windows.UI.Xaml.Controls.MediaElement)this.FindName("MyMediaElement");
            CoverArtist = (global::Windows.UI.Xaml.Controls.Grid)this.FindName("CoverArtist");
            TitlePanel = (global::Windows.UI.Xaml.Controls.Grid)this.FindName("TitlePanel");
            SliderPanel = (global::Windows.UI.Xaml.Controls.Grid)this.FindName("SliderPanel");
            ButtonPanel = (global::Windows.UI.Xaml.Controls.Grid)this.FindName("ButtonPanel");
            PlayButtonToggle = (global::Windows.UI.Xaml.Controls.Primitives.ToggleButton)this.FindName("PlayButtonToggle");
            ShuffleButtonToggle = (global::Windows.UI.Xaml.Controls.Primitives.ToggleButton)this.FindName("ShuffleButtonToggle");
            RepeatButtonToggle = (global::Windows.UI.Xaml.Controls.Primitives.ToggleButton)this.FindName("RepeatButtonToggle");
            RewindImage = (global::Windows.UI.Xaml.Controls.Image)this.FindName("RewindImage");
            ForwardImage = (global::Windows.UI.Xaml.Controls.Image)this.FindName("ForwardImage");
            TimeSlider = (global::Windows.UI.Xaml.Controls.Slider)this.FindName("TimeSlider");
        }
    }
}


