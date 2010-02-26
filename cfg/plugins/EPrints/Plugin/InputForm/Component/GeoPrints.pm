package EPrints::Plugin::InputForm::Component::GeoPrints;

use EPrints::Plugin::InputForm::Component;

@ISA = ( 'EPrints::Plugin::InputForm::Component' );

use strict;

sub new
{
	my( $class, %opts ) = @_;

	my $self = $class->SUPER::new( %opts );

	$self->{name} = "GeoPrints";
	$self->{visible} = "all";

	return $self;
}

sub render_content
{
	my( $self ) = @_;

	my $repository = $self->{repository};
	my $xml = $repository->{xml};
	my $eprint = $self->{eprint};

	my $frag = $xml->create_document_fragment;

	$frag->appendChild( $self->html_phrase( 'description' ) );

	return $frag;
}

sub render_help
{
	my( $self, $surround ) = @_;

	return $self->html_phrase( 'help' );
}

sub render_title
{
	my( $self, $surround )  = @_;

	return $self->html_phrase( 'title' );
}
1;
