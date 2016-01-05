---
layout: post
title: Patchmaster Code Key
tags: ruby, programming, music, midi
---

I'm working on a new feature for [PatchMaster](http://patchmaster.org/):
code keys. Press a key and a block of code gets run.

Here's a silly example:

{% highlight ruby %}
$global_code_key_value = nil

code_key :f3 do
  $global_code_key_value = 42
end
{% end %}

I was prompted to add this feature because I want to be able to capture
program changes on the fly and assign them to key presses. The first part of
that would be capturing program changes:

{% highlight ruby %}
program_changes = {}
most_recent_pc_conn = nil
assigned_program_changes = {}

song "Patch Capturer" do
  patch "Patch Capturer" do
    filter do |conn, bytes|
      # Remember program changes
      if bytes.program_change?
        program_changes[conn] = bytes
        most_recent_program_change_channel = conn
      end
    end
  end
end
{% end %}

Now we need a way to save and use those captured program changes.

{% highlight ruby %}
code_key :f3 do
  name = PromptWindow.new('Save Program Change', 'Save PC to (name):').gets
  assigned_program_changes[name] = [
    most_recent_pc_conn, program_changes[most_recent_pc_conn]
  ]
end

code_key :f4 do
  name = PromptWindow.new('Send Program Change', 'Send PC (name):').gets
  if assigned_program_changes[name]
    conn, bytes = *assigned_program_changes[name]
    conn.midi_out(bytes)
  end
end
{% end %}

The [PatchMaster site](http://patchmaster.org/) site also has a new look.
It's now powered by [Jekyll](jekyllrb.com), which replaces the old version
of the site that was generated from Emacs [Org Mode](http://org-mode.org/)
files.
